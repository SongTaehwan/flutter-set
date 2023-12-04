import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/text_to_speech_api.g.dart',
    kotlinOut:
        'android/app/src/main/kotlin/com/example/pigeons/text_to_speech_api.g.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Runner/text_to_speech_api.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
// Flutter -> Native
@HostApi()
abstract class TextToSpeechHostApi {
  @async
  bool speak(String text);

  @async
  bool stopSpeaking();
}
