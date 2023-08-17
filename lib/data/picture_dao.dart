import 'dart:async';

import 'package:apod/data/model/picture_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PictureDao {
  static const String boxName = 'PictureEntity';

  late final Box<PictureEntity> hiveBox;

  PictureDao() {
    if (Hive.isBoxOpen(boxName)) {
      hiveBox = Hive.box(boxName);
    } else {
      throw Exception(
        'You need to open Hive box \'$boxName\' before creating this object',
      );
    }
  }

  save(List<PictureEntity> entities) async {
    for (final entity in entities) {
      await hiveBox.put(entity.date.toString(), entity);
    }
  }

  Iterable<PictureEntity> getEntities() {
    return hiveBox.values;
  }

  EntityDateRange? getEntityDateRange() {
    final sortedItems = hiveBox.values.toList();
    sortedItems
        .sort((a, b) => a.date.compareTo(b.date)); // ascending order of date
    if (sortedItems.isNotEmpty) {
      return EntityDateRange(
        latest: sortedItems.last.date,
        oldest: sortedItems.first.date,
      );
    }
    return null;
  }

  /// Regardless of how entities are saved (Iteratively or as Map), Listener is notified for each new entry
  /// eg,
  /// Saves 1 item -> Listener is notified single time
  /// Save 10 items -> Listener will be notified 10 times
  Stream<Iterable<PictureEntity>> getEntitiesSteam() {
    return hiveBox.watch().map((event) => hiveBox.values);
  }
}

class EntityDateRange {
  final DateTime latest;
  final DateTime oldest;

  EntityDateRange({required this.latest, required this.oldest});
}
