import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tyman/core/utils/utils.dart';
import 'package:tyman/data/models/task_model.dart';

class DatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final CalendarFormat calendarFormat;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<CalendarFormat>? onFormatChanged;
  final String category;

  const DatePicker({
    super.key,
    required this.selectedDate,
    this.calendarFormat = CalendarFormat.week,
    required this.onDateChanged,
    this.onFormatChanged,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final TaskModel taskColor = TaskModel.fromTitle(category);
    final theme = Theme.of(context);
    return TableCalendar(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: selectedDate,
      selectedDayPredicate: (day) => isSameDay(day, selectedDate),
      calendarFormat: calendarFormat,
      daysOfWeekHeight: kMinInteractiveDimension / 2.2,
      headerStyle: HeaderStyle(
          formatButtonDecoration: BoxDecoration(
        border: BoxBorder.all(
          color: theme.colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(16.0),
      )),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Week View',
        CalendarFormat.week: 'Month View',
      },
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        todayDecoration:
            BoxDecoration(color: taskColor.btnColor, shape: BoxShape.circle),
        selectedDecoration:
            BoxDecoration(color: taskColor.iconColor, shape: BoxShape.circle),
        outsideDaysVisible: false,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
        color: theme.textTheme.bodyMedium!.color,
      )),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(selectedDate, selectedDay)) {
          onDateChanged(selectedDay);
        }
      },
      onFormatChanged: (format) {
        if (onFormatChanged != null && calendarFormat != format) {
          onFormatChanged!(format);
        }
      },
      onPageChanged: (_) {},
    );
  }
}
