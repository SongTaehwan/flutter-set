import 'package:flutter/material.dart';

import 'text_to_speech_api.g.dart';

class TextToSpeechViewModel extends ChangeNotifier {
  final textToSpeechHostApi = TextToSpeechHostApi();
  String _text =
      "When the Buckwheat Flowers Bloom also translated as The Buckwheat Season is a 1936 short story by Korean writer Lee Hyo-seok";
  bool isLoading = false;

  void speak() async {
    if (isLoading) {
      return;
    }

    isLoading = true;
    notifyListeners();
    print("DEBUG: $_text");
    await stopSpeaking();
    await textToSpeechHostApi.speak(_text);

    isLoading = false;
    notifyListeners();
  }

  Future<void> stopSpeaking() async {
    if (isLoading) {
      return;
    }

    isLoading = true;
    notifyListeners();

    await textToSpeechHostApi.stopSpeaking();

    isLoading = false;
    notifyListeners();
  }

  void setText(String text) {
    _text = text;
    notifyListeners();
  }
}
