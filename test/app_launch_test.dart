// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:apod/app.dart';
import 'package:apod/data/model/picture_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  group('app launch test', () {
    setUpAll(() async {
      Hive.init('.');
      Hive.registerAdapter(PictureEntityAdapter());
    });

    tearDownAll(() {});

    testWidgets('home-screen displays app name', (WidgetTester tester) async {
      await tester.pumpWidget(const ApodApp());
      expect(find.text('Astronomy Picture of the Day'), findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}
