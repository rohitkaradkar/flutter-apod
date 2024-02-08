import 'package:apod/app.dart';
import 'package:apod/data/model/picture_entity.dart';
import 'package:apod/data/picture_dao.dart';
import 'package:apod/utils/bloc_observer.dart';
import 'package:apod/utils/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await preRunSetUp();
  runApp(const ApodApp());
}

Future<void> preRunSetUp() async {
  await setUpEnvConfig();

  await setUpFirebase(
    Config.fromEnv(isDebug: kDebugMode, targetPlatform: defaultTargetPlatform),
  );

  await initialiseHive();

  Bloc.observer = SimpleBlocObserver();
}

Future<void> initialiseHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PictureEntityAdapter());
  await Hive.openBox<PictureEntity>(PictureDao.boxName);
}

Future<void> setUpFirebase(Config config) async {
  await Firebase.initializeApp(
    name: 'Apod',
    options: FirebaseOptions(
      apiKey: config.firebaseApiKey,
      appId: config.firebaseAppId,
      messagingSenderId: config.firebaseMessagingSenderId,
      projectId: config.firebaseProjectId,
    ),
  );

  // pass all uncaught exceptions
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // pass all uncaught exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

Future<void> setUpEnvConfig() async {
  await Config.init('config/local.env');
}
