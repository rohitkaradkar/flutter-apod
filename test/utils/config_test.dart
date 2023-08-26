import 'package:apod/utils/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('debug config is loaded', () async {
    await Config.init('config/local.env');
    expect(Config.get('NASA_API_KEY'), 'DEMO_KEY');
  });

  test('create fromEnv', () async {
    dotenv.testLoad(fileInput: '''
    NASA_API_KEY=DEMO_KEY
    FIREBASE_API_KEY_ANDROID_DEBUG=firebaseApiKey
    FIREBASE_APP_ID_ANDROID_DEBUG=firebaseAppId
    FIREBASE_MESSAGING_SENDER_ID=firebaseMessagingSenderId
    FIREBASE_PROJECT_ID=firebaseProjectId
    FIREBASE_STORAGE_BUCKET=firebaseStorageBucket
    ''');

    final config = Config.fromEnv(
      isDebug: true,
      targetPlatform: TargetPlatform.android,
    );

    expect(config, isNotNull);
    expect(config.nasaApiKey, 'DEMO_KEY');
    expect(config.firebaseApiKey, 'firebaseApiKey');
    expect(config.firebaseAppId, 'firebaseAppId');
    expect(config.firebaseMessagingSenderId, 'firebaseMessagingSenderId');
    expect(config.firebaseProjectId, 'firebaseProjectId');
    expect(config.firebaseStorageBucket, 'firebaseStorageBucket');
  });
}
