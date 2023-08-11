import 'package:apod/data/apod_pager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('start and end date should be pageSize apart', () {
    const today = '2021-08-01';
    const pageSize = 10;

    final todayDate = DateTime.parse(today);
    final pager = ApodPager(pageSize: pageSize, today: todayDate);

    final firstPage = pager.getPageData(0);
    expect(firstPage.startDate, today);
    expect(firstPage.endDate, '2021-08-10');

    final secondPage = pager.getPageData(1);
    expect(secondPage.startDate, '2021-08-11');
    expect(secondPage.endDate, '2021-08-20');
  });

  test('withoutTime() extension strips time from DateTime', () {
    final today = DateTime.parse('2023-08-01 01:01:01');
    final todayWithoutTime = today.withoutTime();
    expect(todayWithoutTime, DateTime(2023, 8, 1));
  });

  test('yyyyMMdd pads single digit month and day with 0', () {
    final date = DateTime(2023, 8, 1);
    expect(date.yyyyMMdd, '2023-08-01');

    final date2 = DateTime(2023, 12, 11);
    expect(date2.yyyyMMdd, '2023-12-11');
  });
}
