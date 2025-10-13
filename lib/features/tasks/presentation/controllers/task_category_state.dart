import 'package:table_calendar/table_calendar.dart';
import 'package:tyman/core/constants/task_filters.dart';

class TaskCategoryState {
  final DateTime selectedDate;
  final TaskFilter selectedFilter;
  final bool hasChanges;
  final CalendarFormat calendarFormat;

  const TaskCategoryState(
      {required this.selectedDate,
      required this.selectedFilter,
      this.hasChanges = false,
      this.calendarFormat = CalendarFormat.week});

  TaskCategoryState copyWith({
    DateTime? selectedDate,
    TaskFilter? selectedFilter,
    bool? hasChanges,
    CalendarFormat? calendarFormat,
  }) {
    return TaskCategoryState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      hasChanges: hasChanges ?? this.hasChanges,
      calendarFormat: calendarFormat ?? this.calendarFormat,
    );
  }
}
