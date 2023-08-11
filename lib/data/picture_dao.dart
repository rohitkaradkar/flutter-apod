import 'package:apod/data/model/picture_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PictureDao {
  PictureDao();

  Future<Box<PictureEntity>> get hiveBox =>
      Hive.openBox<PictureEntity>('PictureEntity');

  save(List<PictureEntity> entities) async {
    for (final entity in entities) {
      final box = await hiveBox;
      await box.put(entity.date.toString(), entity);
    }
  }

  Future<Iterable<PictureEntity>> getEntities() async {
    return await hiveBox.then((box) => box.values);
  }

  /// Regardless of how entities are saved (Iteratively or as Map), Listener is notified for each new entry
  /// eg,
  /// Saves 1 item -> Listener is notified single time
  /// Save 10 items -> Listener will be notified 10 times
  Future<void> addListener(VoidCallback listener) async {
    await hiveBox.then((box) => box.listenable().addListener(listener));
  }

  Future<void> removeListener(VoidCallback listener) async {
    await hiveBox.then((box) => box.listenable().removeListener(listener));
  }
}
