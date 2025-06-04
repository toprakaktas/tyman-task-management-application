import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/data/models/app_user.dart';
import 'package:tyman/data/models/task_data.dart';
import 'package:tyman/data/services/task_service.dart';
import 'package:tyman/data/services/user_service.dart';
import 'package:tyman/features/tasks/presentation/widgets/tasks.dart';
import 'package:tyman/features/profile/presentation/my_page.dart';
import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/features/tasks/presentation/widgets/upcoming_tasks.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<TaskModel>> taskCategories;
  AppUser? appUser;

  @override
  void initState() {
    super.initState();
    taskCategories = TaskService().fetchTaskCountsForCategories();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      appUser = await UserService().fetchUserProfile(firebaseUser.uid);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _refreshData() async {
    if (mounted) {
      setState(() {
        taskCategories = TaskService().fetchTaskCountsForCategories();
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  ImageProvider _getImageProvider(String photoUrl) {
    if (photoUrl.startsWith('assets/images')) {
      return AssetImage(photoUrl);
    } else {
      File file = File(photoUrl);
      if (file.existsSync() && file.lengthSync() > 0) {
        return FileImage(file);
      } else {
        return const AssetImage('assets/images/userAvatar.png');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: FutureBuilder<List<TaskModel>>(
        future: taskCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UpcomingTasks(),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: const Text(
                      'Tasks',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Tasks(taskCategories: snapshot.data!),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: buildBottomNavBar(context),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.black,
        onPressed: () {
          TextEditingController descriptionController = TextEditingController();
          DateTime selectedDate = DateTime.now();
          TimeOfDay selectedTime = TimeOfDay.now();
          String dropdownValue = 'Personal';

          Future<void> selectDate(
              BuildContext context, StateSetter setState) async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );
            if (picked != null && picked != selectedDate) {
              if (mounted) {
                setState(
                  () {
                    selectedDate = picked;
                  },
                );
              }
              if (kDebugMode) {
                print('Selected Date: $selectedDate');
              }
            }
          }

          Future<void> selectTime(
              BuildContext context, Function updateTime) async {
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
                        height:
                            MediaQuery.of(context).copyWith().size.height / 3,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.time,
                          initialDateTime: DateTime.now(),
                          onDateTimeChanged: (DateTime newTime) {
                            tempSelectedTime = newTime;
                            if (kDebugMode) {
                              print("New Time: $newTime");
                            }
                            if (mounted) {
                              setState(() {
                                selectedTime = TimeOfDay.fromDateTime(newTime);
                              });
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
                              updateTime(tempSelectedTime);
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

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  title: const Row(
                    children: [
                      Icon(CupertinoIcons.add_circled, color: taskColor),
                      SizedBox(width: 10),
                      Text(
                        'Add New Task',
                        style: TextStyle(
                            color: CupertinoColors.darkBackgroundGray),
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                      child: ListBody(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.collections,
                                color: taskColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down_rounded),
                                elevation: 16,
                                style: const TextStyle(
                                    color: CupertinoColors.darkBackgroundGray),
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  labelStyle: const TextStyle(
                                      color:
                                          CupertinoColors.darkBackgroundGray),
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
                                      dropdownValue = newValue!;
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
                                          color: CupertinoColors
                                              .darkBackgroundGray),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: taskColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))))),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        leading: const Icon(
                          CupertinoIcons.calendar_today,
                          color: taskColor,
                        ),
                        title: Text(
                            "Due Date: ${DateFormat('dd/MM/yy').format(selectedDate)}",
                            style: const TextStyle(
                                color: CupertinoColors.darkBackgroundGray)),
                        trailing: const Icon(Icons.keyboard_arrow_down),
                        onTap: () => selectDate(context, setState),
                      ),
                      ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          leading:
                              const Icon(CupertinoIcons.time, color: taskColor),
                          title: Text(
                              "Due Time: ${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}"),
                          trailing: const Icon(Icons.keyboard_arrow_down),
                          onTap: () => selectTime(context, (newTime) {
                                if (mounted) {
                                  setState((() {
                                    selectedTime =
                                        TimeOfDay.fromDateTime(newTime);
                                  }));
                                }
                              }))
                    ],
                  )),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        String description = descriptionController.text;
                        String category = dropdownValue;
                        TaskData newTask = TaskData(
                          id: '',
                          category: category,
                          description: description,
                          dueDateTime: DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute),
                        );
                        TaskService().addTask(newTask).then((_) {
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            _refreshData();
                            _showSnackBar('Task successfully added!');
                          }
                        });
                      },
                      child: const Text(
                        'Add Task',
                        style: TextStyle(color: taskColor),
                      ),
                    ),
                  ],
                  backgroundColor: Colors.grey[200],
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                );
              });
            },
          );
        },
        child: const Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          if (appUser != null)
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CircleAvatar(
                  backgroundImage: _getImageProvider(appUser!.photo),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          const SizedBox(width: 10),
          Text(
            "Hello, ${appUser?.name ?? 'Earthling'}!",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: const Color.fromARGB(255, 63, 117, 212),
            unselectedItemColor: Colors.grey.withValues(alpha: 0.75),
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home_rounded),
              ),
              BottomNavigationBarItem(
                label: 'My Page',
                icon: Icon(Icons.person_rounded),
              ),
            ],
            onTap: (index) {
              if (index == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MyPage()),
                );
              }
            }),
      ),
    );
  }
}
