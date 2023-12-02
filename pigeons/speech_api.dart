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
class SpeechText {
  final String text;
  SpeechText(this.text);
}

// 네이티브에서 정의할 API
@HostApi()
abstract class SpeechApi {
  SpeechText startRecord();
  void stopRecord();
}
