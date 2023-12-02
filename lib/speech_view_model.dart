import 'package:flutter/material.dart';

import 'speech_api.g.dart';

enum Language { korean, english }

extension on Language {
  String toLocale() {
    switch (this) {
      case Language.korean:
        return "ko_KR";
      case Language.english:
        return "en_US";
    }
  }
}

class SpeechViewModel extends ChangeNotifier implements SpeechFlutterApi {
  final speechApi = SpeechHostApi();
  bool isRecording = false;
  String text = "Nothing";
  Language language = Language.korean;

  setLanguage(Language language) {
    this.language = language;
    print("DEBUG_LANGUAGE: ${this.language.toLocale()}");
    notifyListeners();
  }

  startRecording() async {
    if (isRecording == true) {
      // TODO: Throw Error
      return;
    }

    try {
      await speechApi.startRecording(language.toLocale());
      isRecording = true;
      notifyListeners();
    } catch (error) {
      print("ERROR_RECORDING_START: ${error.toString()}");
    }
  }

  stopRecording() async {
    if (isRecording == false) {
      // TODO: Throw Error
      return;
    }

    try {
      await speechApi.stopRecording();
      isRecording = false;
      text = "Nothing";
      notifyListeners();
    } catch (error) {
      print("ERROR_RECORDING_STOP: ${error.toString()}");
    }
  }

  @override
  sendSpeechText(String text) {
    print("DEBUG: Incoming text: $text");
    this.text = text;
    notifyListeners();
  }
}
