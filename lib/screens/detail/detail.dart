import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tyman/constants/colors.dart';
import 'package:tyman/screens/detail/task_data.dart';
import 'package:tyman/screens/detail/widgets/date_picker.dart';
import 'package:tyman/screens/detail/widgets/task_title.dart';
import 'package:tyman/screens/home/home.dart';
import 'package:tyman/services/firestore_services.dart';

class DetailPage extends StatefulWidget {
  final String categoryFilter;
  const DetailPage({super.key, required this.categoryFilter});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<TaskData>> tasksFuture;
  DateTime selectedDate = DateTime.now();
  String selectedFilter = 'Time';
  @override
  void initState() {
    super.initState();
    tasksFuture = loadTasks();
  }

  Future<List<TaskData>> loadTasks() async {
    List<TaskData> tasks = await FirestoreService()
        .getTasksByCategoryAndDate(widget.categoryFilter, selectedDate);
    if (selectedFilter == 'Deadline') {
      tasks.sort(((a, b) => a.dueDateTime.compareTo(b.dueDateTime)));
    } else if (selectedFilter == 'Description') {
      tasks.sort(((a, b) => a.description.compareTo(b.description)));
    }
    if (kDebugMode) {
      print("Loaded tasks: ${tasks.length}");
    }
    for (var task in tasks) {
      if (kDebugMode) {
        print(task.description);
      }
    }
    return tasks;
  }

  void onDateSelected(DateTime newDate) {
    if (!isSameDay(selectedDate, newDate)) {
      if (mounted) {
        setState(() {
          selectedDate = newDate;
          tasksFuture = loadTasks();
        });
      }
    }
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM - HH:mm').format(dateTime);
  }

  void onFilterSelected(String filter) {
    if (mounted) {
      setState(() {
        selectedFilter = filter;
        tasksFuture = loadTasks();
      });
    }
  }

  void _showCustomAlertDialog(BuildContext context, String title,
      String message, IconData icon, Color iconColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(color: iconColor),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  void editTask(TaskData task) async {
    final editedTask = await showDialog<TaskData>(
      context: context,
      builder: (context) {
        final descriptionController =
            TextEditingController(text: task.description);
        DateTime dueDate = task.dueDateTime;
        TimeOfDay dueTime = TimeOfDay.fromDateTime(task.dueDateTime);
        String category = task.category;

        Future<void> selectDate(
            BuildContext context, StateSetter setState) async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: dueDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2101),
          );
          if (picked != null && picked != dueDate) {
            if (mounted) {
              setState(() {
                dueDate = picked;
              });
            }
            if (kDebugMode) {
              print('Selected Date: $dueDate');
            }
          }
        }

        Future<void> selectTime(
            BuildContext context, StateSetter setState) async {
          DateTime tempSelectedTime = DateTime.now();

          await showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: CupertinoColors.systemGrey6,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).copyWith().size.height / 3,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (DateTime newTime) {
                          tempSelectedTime = newTime;
                          if (kDebugMode) {
                            print("New Time: $newTime");
                          }
                        },
                        use24hFormat: true,
                        minuteInterval: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CupertinoButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: const Text('Cancel',
                              style: TextStyle(
                                  color: CupertinoColors.destructiveRed)),
                        ),
                        const SizedBox(width: 20),
                        CupertinoButton(
                          onPressed: () {
                            if (mounted) {
                              setState(() {
                                dueTime =
                                    TimeOfDay.fromDateTime(tempSelectedTime);
                              });
                            }
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: const Text('OK',
                              style: TextStyle(color: taskColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(CupertinoIcons.pen, color: taskColor),
                  SizedBox(width: 10),
                  Text('Edit Task'),
                ],
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.collections,
                              color: taskColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: category,
                              icon: const Icon(Icons.arrow_drop_down_rounded),
                              elevation: 16,
                              style: const TextStyle(
                                  color: CupertinoColors.darkBackgroundGray),
                              decoration: InputDecoration(
                                labelText: 'Category',
                                labelStyle: const TextStyle(
                                    color: CupertinoColors.darkBackgroundGray),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: taskColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                              ),
                              onChanged: (String? newValue) {
                                if (mounted) {
                                  setState(() {
                                    category = newValue!;
                                  });
                                }
                              },
                              items: <String>[
                                'Personal',
                                'Work',
                                'Health',
                                'Other'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.doc_plaintext,
                              color: taskColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                    color: CupertinoColors.darkBackgroundGray),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: taskColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      leading: const Icon(CupertinoIcons.calendar_today,
                          color: taskColor),
                      title: Text(
                        "Due Date: ${DateFormat('dd/MM/yy').format(dueDate)}",
                        style: const TextStyle(
                            color: CupertinoColors.darkBackgroundGray),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_down),
                      onTap: () => selectDate(context, setState),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      leading:
                          const Icon(CupertinoIcons.time, color: taskColor),
                      title: Text(
                        "Due Time: ${dueTime.hour}:${dueTime.minute.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                            color: CupertinoColors.darkBackgroundGray),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_down),
                      onTap: () => selectTime(context, setState),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final updatedTask = TaskData(
                      id: task.id,
                      category: category,
                      description: descriptionController.text,
                      dueDateTime: DateTime(
                        dueDate.year,
                        dueDate.month,
                        dueDate.day,
                        dueTime.hour,
                        dueTime.minute,
                      ),
                      completed: task.completed,
                    );
                    Navigator.of(context).pop(updatedTask);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (editedTask != null) {
      try {
        await FirestoreService().updateTask(editedTask);
        if (mounted) {
          setState(() {
            tasksFuture = loadTasks();
          });
        }
        _showCustomAlertDialog(context, 'Success', 'Task updated successfully!',
            Icons.check_circle, CupertinoColors.activeGreen);
      } catch (e) {
        _showCustomAlertDialog(context, 'Error', 'Failed to update task: $e',
            Icons.error, Colors.red);
      }
    }
  }

  void deleteTask(TaskData task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(CupertinoIcons.trash),
              SizedBox(width: 10),
              Text('Delete Task',
                  style: TextStyle(color: CupertinoColors.destructiveRed)),
            ],
          ),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete',
                  style: TextStyle(
                      color: CupertinoColors.destructiveRed, fontSize: 13)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await FirestoreService().deleteTask(task.id);
        if (mounted) {
          setState(() {
            tasksFuture = loadTasks();
          });
        }
        _showCustomAlertDialog(context, 'Success',
            'Task deleted successfully!.', Icons.delete, Colors.red);
      } catch (e) {
        _showCustomAlertDialog(context, 'Error', 'Failed to delete task: $e',
            Icons.error, Colors.red);
      }
    }
  }

  void markTaskAsDone(TaskData task) async {
    final updatedTask = TaskData(
      id: task.id,
      category: task.category,
      description: task.description,
      dueDateTime: task.dueDateTime,
      completed: !task.completed,
    );

    try {
      await FirestoreService().updateTask(updatedTask);
      if (mounted) {
        setState(() {
          tasksFuture = loadTasks();
        });
      }
      String message = updatedTask.completed
          ? 'Well done! You have completed the task!'
          : 'Task marked as not completed.';
      _showCustomAlertDialog(
          context, 'Success', message, Icons.check_circle, Colors.green);
    } catch (e) {
      _showCustomAlertDialog(context, 'Error',
          'Failed to mark task as done: $e', Icons.error, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder<List<TaskData>>(
          future: tasksFuture,
          builder: (context, snapshot) {
            int taskLeft = 0;
            if (snapshot.hasData && snapshot.data != null) {
              taskLeft = snapshot.data!
                  .where((task) => task.completed == false)
                  .length;
            }
            List<Widget> slivers = [
              buildAppBar(context, taskLeft),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      DatePicker(onDateChanged: onDateSelected),
                      TaskTitle(onFilterSelected: onFilterSelected),
                    ],
                  ),
                ),
              ),
            ];

            if (snapshot.connectionState == ConnectionState.waiting) {
              slivers.add(
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              slivers.add(
                SliverFillRemaining(
                  child: Container(
                    color: Colors.white,
                    child: const Center(
                      child: Text('There are no tasks for today.',
                          style: TextStyle(color: Colors.grey, fontSize: 18)),
                    ),
                  ),
                ),
              );
            } else {
              slivers.add(
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      TaskData task = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 1),
                        color: task.completed
                            ? markedTaskColor
                            : CupertinoColors.systemGrey5,
                        child: ListTile(
                          leading: IconButton(
                            onPressed: () => markTaskAsDone(task),
                            icon: const Icon(CupertinoIcons.check_mark_circled,
                                color: completeTaskColor),
                          ),
                          title: Text(task.description,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          subtitle:
                              Text('Due Time: ${formatDate(task.dueDateTime)}'),
                          trailing: Wrap(spacing: 5, children: <Widget>[
                            IconButton(
                                onPressed: () => editTask(task),
                                icon: const Icon(CupertinoIcons.pen)),
                            IconButton(
                                onPressed: () => deleteTask(task),
                                icon: const Icon(
                                  CupertinoIcons.trash,
                                  color: Color(0xFFF74F43),
                                )),
                          ]),
                        ),
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),
                ),
              );
            }

            return CustomScrollView(
              slivers: slivers,
            );
          },
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(BuildContext context, int taskLeft) {
    String taskText;
    if (taskLeft == 1) {
      taskText = "$taskLeft task for today!";
    } else {
      taskText = "$taskLeft tasks for today!";
    }

    return SliverAppBar(
      pinned: true,
      expandedHeight: 90,
      backgroundColor: Colors.black,
      leading: IconButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage())),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        iconSize: 20,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.categoryFilter} tasks',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 5),
            Text(
              taskText,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }
}
