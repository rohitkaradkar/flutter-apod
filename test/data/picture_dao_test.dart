import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/data/picture_dao.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  group('picture dao test', () {
    late Box<PictureEntity> testBox;
    setUpAll(() async {
      Hive.init('.');
      Hive.registerAdapter(PictureEntityAdapter());
      testBox = await Hive.openBox<PictureEntity>(PictureDao.boxName);
    });

    tearDownAll(() async {
      await testBox.deleteFromDisk();
      Hive.close();
    });

    final fakeEntities = [
      PictureEntity(
        date: DateTime.parse('2021-08-01'),
        explanation: 'details',
        hdImageUrl: 'hdImageUrl',
        imageUrl: 'imageUrl',
        title: 'title',
      ),
      PictureEntity(
        date: DateTime.parse('2021-08-02'),
        explanation: 'details',
        hdImageUrl: 'hdImageUrl',
        imageUrl: 'imageUrl',
        title: 'title',
      ),
    ];

    late PictureDao pictureDao;

    setUp(() async {
      pictureDao = PictureDao();
    });

    tearDown(() async {
      await pictureDao.hiveBox.clear();
    });

    test('dao is initialised', () async {
      expect(pictureDao, isNotNull);
    });

    test('saved entities are accessible', () async {
      await pictureDao.save(fakeEntities);

      final savedEntities = pictureDao.getEntities();
      expect(savedEntities.length, fakeEntities.length);
      for (final savedEntity in savedEntities) {
        expect(fakeEntities.contains(savedEntity), isTrue);
      }
    });

    test('entities with same dates are overridden', () async {
      final oldEntity = PictureEntity(
        date: DateTime.parse('2021-08-01'),
        explanation: 'details',
        hdImageUrl: 'hdImageUrl',
        imageUrl: 'imageUrl',
        title: 'title',
      );
      final newEntity = PictureEntity(
        date: DateTime.parse('2021-08-01'),
        explanation: 'new details',
        hdImageUrl: 'new hdImageUrl',
        imageUrl: 'imageUrl',
        title: 'title',
      );

      await pictureDao.save([oldEntity]);
      await pictureDao.save([newEntity]);

      final savedEntities = pictureDao.getEntities();
      expect(savedEntities.length, 1);
      expect(savedEntities.first, newEntity);
    });

    test('stream listener is notified when database changes', () async {
      var changeCount = 0;

      final subscription = pictureDao.getEntitiesSteam().listen((_) {
        changeCount++;
      });

      expect(changeCount, 0);
      await pictureDao.save(fakeEntities);

      expect(changeCount, fakeEntities.length);
      subscription.cancel();
    });
  });
}
