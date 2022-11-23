
extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  // String messageTimeForChat() {
  //   final difference = DateTime.now().difference(this).inDays;
  //
  //   if (isToday()) {
  //     return DateFormat('hh:mm a').format(this);
  //   } else if (isYesterday()) {
  //     return LocalizationString.yesterday;
  //   } else if (difference < 7) {
  //     return DateFormat('EEEE').format(this);
  //   }
  //   return DateFormat('dd-MMM-yyyy').format(this);
  // }

  bool isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

}
