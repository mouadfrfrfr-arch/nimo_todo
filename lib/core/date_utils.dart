class DateUtilsX {
  static DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime startOfNextDay(DateTime d) {
    final s = startOfDay(d);
    return s.add(const Duration(days: 1));
  }
}
