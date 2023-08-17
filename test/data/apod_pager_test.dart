import 'package:apod/data/apod_pager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('start and end date should be pageSize apart', () {
    const today = '2023-08-11';
    const pageSize = 10;

    final todayDate = DateTime.parse(today);
    final pager = ApodPager(pageSize: pageSize, today: todayDate);

    final firstPage = pager.getPageData(0);
    expect(firstPage.endDate, today);
    expect(firstPage.startDate, '2023-08-02');

    final secondPage = pager.getPageData(1);
    expect(secondPage.endDate, '2023-08-01');
    expect(secondPage.startDate, '2023-07-23');
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

  test('nextPage returns latest dates when local entities are older', () {
    final today = DateTime(2023, 8, 17);
    final pager = ApodPager(pageSize: 5, today: today);

    final page1 = pager.getNextPage(
      latestEntityDate: DateTime(2023, 8, 10),
      oldestEntityDate: DateTime(2023, 8, 1),
    )!;
    expect(page1.endDate, '2023-08-15');
    expect(page1.startDate, '2023-08-11');

    final page2 = pager.getNextPage(
      latestEntityDate: DateTime(2023, 8, 15),
      oldestEntityDate: DateTime(2023, 8, 1),
    )!;
    expect(page2.endDate, '2023-08-17');
    expect(page2.startDate, '2023-08-16');
  });

  test('nextPage returns past dates from local entities', () {
    final today = DateTime(2023, 8, 17);
    final pager = ApodPager(pageSize: 5, today: today);

    final page1 = pager.getNextPage(
      latestEntityDate: today,
      oldestEntityDate: DateTime(2023, 8, 1),
    )!;
    expect(page1.endDate, '2023-07-31');
    expect(page1.startDate, '2023-07-27');

    final page2 = pager.getNextPage(
      latestEntityDate: today,
      oldestEntityDate: DateTime(2023, 7, 27),
    )!;
    expect(page2.endDate, '2023-07-26');
    expect(page2.startDate, '2023-07-22');
  });
}
