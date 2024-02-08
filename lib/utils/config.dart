import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// A Config class to access local .env files. eg, config/local.env
final class Config extends Equatable {
  static Future<void> init(String fileName) async {
    await dotenv.load(fileName: fileName);
  }

  static String get(String key, {String? fallback}) {
    return dotenv.get(key, fallback: fallback);
  }

  static Config fromEnv({
    required bool isDebug,
    required TargetPlatform targetPlatform,
  }) {
    assert(dotenv.isInitialized);

    final String firebaseAppId;
    final String firebaseApiKey;

    switch (targetPlatform) {
      case TargetPlatform.android:
        firebaseAppId = isDebug
            ? 'FIREBASE_APP_ID_ANDROID_DEBUG'
            : 'FIREBASE_APP_ID_ANDROID_RELEASE';
        firebaseApiKey = isDebug
            ? 'FIREBASE_API_KEY_ANDROID_DEBUG'
            : 'FIREBASE_API_KEY_ANDROID_RELEASE';
        break;
      case TargetPlatform.iOS:
        firebaseAppId = isDebug
            ? 'FIREBASE_APP_ID_IOS_DEBUG'
            : 'FIREBASE_APP_ID_IOS_RELEASE';
        firebaseApiKey = isDebug
            ? 'FIREBASE_API_KEY_IOS_DEBUG'
            : 'FIREBASE_API_KEY_IOS_RELEASE';
        break;
      default:
        throw UnsupportedError('Unsupported platform');
    }

    return Config(
      nasaApiKey: get('NASA_API_KEY'),
      firebaseApiKey: get(firebaseApiKey),
      firebaseAppId: get(firebaseAppId),
      firebaseMessagingSenderId: get('FIREBASE_MESSAGING_SENDER_ID'),
      firebaseProjectId: get('FIREBASE_PROJECT_ID'),
      firebaseStorageBucket: get('FIREBASE_STORAGE_BUCKET'),
    );
  }

  Config({
    required this.nasaApiKey,
    required this.firebaseApiKey,
    required this.firebaseAppId,
    required this.firebaseMessagingSenderId,
    required this.firebaseProjectId,
    required this.firebaseStorageBucket,
  });

  final String nasaApiKey;
  final String firebaseApiKey;
  final String firebaseAppId;
  final String firebaseMessagingSenderId;
  final String firebaseProjectId;
  final String firebaseStorageBucket;

  @override
  List<Object> get props => [
        nasaApiKey,
        firebaseApiKey,
        firebaseAppId,
        firebaseMessagingSenderId,
        firebaseProjectId,
        firebaseStorageBucket,
      ];

  @override
  bool? get stringify => true;
}
