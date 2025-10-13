import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tyman/core/utils/utils.dart';

class DatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final CalendarFormat calendarFormat;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<CalendarFormat>? onFormatChanged;

  const DatePicker({
    super.key,
    required this.selectedDate,
    this.calendarFormat = CalendarFormat.week,
    required this.onDateChanged,
    this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: selectedDate,
      selectedDayPredicate: (day) => isSameDay(day, selectedDate),
      calendarFormat: calendarFormat,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Week View',
        CalendarFormat.week: 'Month View',
      },
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
      ),
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
