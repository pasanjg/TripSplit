import 'dart:math';
import 'dart:ui';

String generateRandomCode(int length) {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

Color generateColorFromString(String input) {
  final hash = input.hashCode;
  final r = (hash & 0xFF0000) >> 16;
  final g = (hash & 0x00FF00) >> 8;
  final b = (hash & 0x0000FF);
  return Color.fromARGB(255, r, g, b);
}

List<DateTime> generateDateRange(List<DateTime> dates) {
  if (dates.isEmpty) return [];

  DateTime earliestDate = dates.reduce((a, b) => a.isBefore(b) ? a : b);
  DateTime latestDate = dates.reduce((a, b) => a.isAfter(b) ? a : b);

  List<DateTime> dateRange = [];
  DateTime currentDate = earliestDate;

  while (currentDate.isBefore(latestDate) || currentDate.isAtSameMomentAs(latestDate)) {
    dateRange.add(currentDate);
    currentDate = currentDate.add(const Duration(days: 1));
  }

  return dateRange;
}
