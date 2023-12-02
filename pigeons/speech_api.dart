import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/speech_api.g.dart',
    kotlinOut:
        'android/app/src/main/kotlin/com/example/pigeons/speech_api.g.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Runner/speech_api.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
// Flutter -> Native
@HostApi()
abstract class SpeechHostApi {
  @async
  void startRecording(String language);

  @async
  void stopRecording();
}

// Native -> Flutter
@FlutterApi()
abstract class SpeechFlutterApi {
  void sendSpeechText(String text);
}
