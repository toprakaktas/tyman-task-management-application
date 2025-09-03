import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/core/utils/snackbar_helper.dart';
import 'package:tyman/data/models/task_data.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, required this.onAdd, this.onAdded});

  final Future<void> Function(TaskData) onAdd;
  final VoidCallback? onAdded;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _dropdownValue = 'Personal';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
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
                height: MediaQuery.of(context).size.height / 3,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newTime) {
                    tempSelectedTime = newTime;
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
                        style:
                            TextStyle(color: CupertinoColors.destructiveRed)),
                  ),
                  const SizedBox(width: 20),
                  CupertinoButton(
                    onPressed: () {
                      setState(() {
                        _selectedTime =
                            TimeOfDay.fromDateTime(tempSelectedTime);
                      });
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: const Text('OK', style: TextStyle(color: taskColor)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(CupertinoIcons.add_circled, color: taskColor),
          SizedBox(width: 10),
          Text(
            'Add New Task',
            style: TextStyle(color: CupertinoColors.darkBackgroundGray),
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
                  const Icon(CupertinoIcons.collections, color: taskColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      elevation: 16,
                      style: const TextStyle(
                          color: CupertinoColors.darkBackgroundGray),
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: const TextStyle(
                            color: CupertinoColors.darkBackgroundGray),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: taskColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Personal', 'Work', 'Health', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
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
                  const Icon(CupertinoIcons.doc_plaintext, color: taskColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                            color: CupertinoColors.darkBackgroundGray),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: taskColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
              leading: const Icon(
                CupertinoIcons.calendar_today,
                color: taskColor,
              ),
              title: Text(
                "Due Date: ${DateFormat('dd/MM/yy').format(_selectedDate)}",
                style:
                    const TextStyle(color: CupertinoColors.darkBackgroundGray),
              ),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              leading: const Icon(CupertinoIcons.time, color: taskColor),
              title: Text(
                  "Due Time: ${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}"),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: () => _selectTime(context),
            ),
          ],
        ),
      ),
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
            final description = _descriptionController.text;
            final category = _dropdownValue;
            final newTask = TaskData(
              id: '',
              category: category,
              description: description,
              dueDateTime: DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day,
                _selectedTime.hour,
                _selectedTime.minute,
              ),
            );
            widget.onAdd(newTask).then((_) {
              if (context.mounted) {
                Navigator.of(context).pop();
                widget.onAdded?.call();
                showSnackBar(context, 'Task successfully added!');
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
  }
}
