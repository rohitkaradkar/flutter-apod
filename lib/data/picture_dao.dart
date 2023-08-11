import 'package:apod/data/model/picture_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PictureDao {
  static Future<PictureDao> create(String boxName) async {
    final box = await Hive.openBox<PictureEntity>(boxName);
    return PictureDao(box);
  }

  final Box<PictureEntity> box;

  PictureDao(this.box);

  save(List<PictureEntity> entities) async {
    for (final entity in entities) {
      await box.put(entity.date.toString(), entity);
    }
  }

  Iterable<PictureEntity> getEntities() {
    return box.values;
  }

  /// Regardless of how entities are saved (Iteratively or as Map), Listener is notified for each new entry
  /// eg,
  /// Saves 1 item -> Listener is notified single time
  /// Save 10 items -> Listener will be notified 10 times
  void addListener(VoidCallback listener) {
    box.listenable().addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    box.listenable().removeListener(listener);
  }
}
