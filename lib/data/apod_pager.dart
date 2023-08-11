class ApodPager {
  final int pageSize;
  final DateTime today;

  ApodPager({required this.pageSize, DateTime? today})
      : today = today?.withoutTime() ?? DateTime.now().withoutTime();

  ApodPageData getPageData(int pageIndex) {
    final startDate = today.add(Duration(days: pageIndex * pageSize));
    final endDate = startDate.add(Duration(days: pageSize - 1));
    return ApodPageData(startDate: startDate, endDate: endDate);
  }
}

class ApodPageData {
  final String startDate;
  final String endDate;

  ApodPageData({required DateTime startDate, required DateTime endDate})
      : startDate = startDate.yyyyMMdd,
        endDate = endDate.yyyyMMdd;
}

extension DateUtils on DateTime {
  DateTime withoutTime() {
    return DateTime(year, month, day);
  }

  String get yyyyMMdd {
    return '${year.toString()}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}
