enum TaskFilter {
  orderBy('Order By'),
  time('Time'),
  description('Description');

  final String label;

  const TaskFilter(this.label);
}
