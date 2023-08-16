import 'package:apod/app.dart';
import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/data/picture_dao.dart';
import 'package:apod/utils/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PictureEntityAdapter());
  await Hive.openBox<PictureEntity>(PictureDao.boxName);
  Bloc.observer = SimpleBlocObserver();
  runApp(const ApodApp());
}
