import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tyman/core/constants/colors.dart';
import 'package:tyman/data/models/task_data.dart';

class EditTaskDialog extends StatefulWidget {
  final TaskData task;

  const EditTaskDialog({super.key, required this.task});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController _descriptionControlller;
  late DateTime _dueDate;
  late TimeOfDay _dueTime;
  late String _category;

  @override
  void initState() {
    super.initState();
    _descriptionControlller =
        TextEditingController(text: widget.task.description);
    _dueDate = widget.task.dueDateTime;
    _dueTime = TimeOfDay.fromDateTime(widget.task.dueDateTime);
    _category = widget.task.category;
  }

  @override
  void dispose() {
    _descriptionControlller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
              data: theme.copyWith(
                  cardTheme: theme.cardTheme,
                  textTheme: theme.textTheme,
                  colorScheme: theme.colorScheme,
                  brightness: theme.brightness,
                  iconButtonTheme: theme.iconButtonTheme,
                  unselectedWidgetColor: theme.unselectedWidgetColor),
              child: child!);
        });
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    DateTime tempSelectedTime = DateTime.now();
    final theme = Theme.of(context);
    await showCupertinoModalPopup(
        context: context,
        builder: (_) => SafeArea(
              bottom: true,
              child: Container(
                color: theme.colorScheme.secondary,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (newTime) =>
                            tempSelectedTime = newTime,
                        use24hFormat: true,
                        minuteInterval: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CupertinoButton(
                            onPressed: () => Navigator.of(context).pop(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: deleteTaskColor),
                            )),
                        const SizedBox(width: 20),
                        CupertinoButton(
                          onPressed: () {
                            setState(() => _dueTime =
                                TimeOfDay.fromDateTime(tempSelectedTime));
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: const Text(
                            'OK',
                            style: TextStyle(color: taskColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Row(
        children: [
          Icon(CupertinoIcons.pen, color: taskColor),
          SizedBox(width: 10),
          Text(
            'Edit Task',
            style: TextStyle(color: theme.textTheme.bodyLarge!.color),
          )
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.collections,
                  color: taskColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(25),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    menuMaxHeight: kMinInteractiveDimension * 4.4,
                    itemHeight: kMinInteractiveDimension,
                    enableFeedback: true,
                    initialValue: _category,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    elevation: 16,
                    style: TextStyle(color: theme.textTheme.bodyLarge!.color),
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle:
                          TextStyle(color: theme.textTheme.bodyLarge!.color),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: taskColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 10),
                    ),
                    onChanged: (String? newValue) {
                      setState(() => _category = newValue!);
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
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        cursorHeight: 20,
                        minLines: 1,
                        maxLines: 2,
                        style: TextStyle(
                            color: theme.textTheme.labelLarge!.color,
                            fontWeight: theme.textTheme.labelLarge!.fontWeight,
                            fontSize: theme.textTheme.labelLarge!.fontSize),
                        cursorOpacityAnimates: true,
                        controller: _descriptionControlller,
                        decoration: InputDecoration(
                            isDense: true,
                            floatingLabelStyle: TextStyle(
                              color: theme.textTheme.bodyLarge!.color,
                            ),
                            labelText: 'Description',
                            labelStyle: TextStyle(
                              color: theme.textTheme.labelLarge!.color,
                              fontWeight:
                                  theme.textTheme.labelLarge!.fontWeight,
                              fontSize: theme.textTheme.labelLarge!.fontSize,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: taskColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ))))
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            leading:
                const Icon(CupertinoIcons.calendar_today, color: taskColor),
            title: Text('Due Date: ${DateFormat('dd/MM/yy').format(_dueDate)}',
                style: TextStyle(
                  color: theme.textTheme.labelLarge!.color,
                  fontWeight: theme.textTheme.labelLarge!.fontWeight,
                  fontSize: theme.textTheme.labelLarge!.fontSize,
                )),
            contentPadding: EdgeInsets.zero,
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(CupertinoIcons.time, color: taskColor),
            title: Text(
              'Due Time: ${_dueTime.hour}:${_dueTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: theme.textTheme.labelLarge!.color,
                fontWeight: theme.textTheme.labelLarge!.fontWeight,
                fontSize: theme.textTheme.labelLarge!.fontSize,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: () => _selectTime(context),
          ),
        ]),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.redAccent),
            )),
        TextButton(
            onPressed: () {
              final updatedTask = TaskData(
                  id: widget.task.id,
                  category: _category,
                  description: _descriptionControlller.text,
                  dueDateTime: DateTime(
                    _dueDate.year,
                    _dueDate.month,
                    _dueDate.day,
                    _dueTime.hour,
                    _dueTime.minute,
                  ),
                  completed: widget.task.completed);
              Navigator.of(context).pop(updatedTask);
            },
            child: const Text('Save',
                style:
                    TextStyle(color: taskColor, fontWeight: FontWeight.bold)))
      ],
      backgroundColor: theme.colorScheme.secondary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}
