import 'package:flutter/material.dart';

import 'speech_api.g.dart';

class SpeechViewModel extends ChangeNotifier implements SpeechFlutterApi {
  final speechApi = SpeechHostApi();
  bool isRecording = false;
  String text = "Nothing";

  startRecording() async {
    if (isRecording == true) {
      // TODO: Throw Error
      return;
    }

    try {
      await speechApi.startRecording();
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
