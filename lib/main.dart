import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_app/speech_api.g.dart';
import 'package:speech_app/text_to_speech_view_model.dart';

import 'speech_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) {
              final viewModel = SpeechViewModel();
              // 채널 등록(From Native to Flutter App)
              SpeechFlutterApi.setup(viewModel);
              return viewModel;
            },
          ),
          ChangeNotifierProvider(
            create: (_) => TextToSpeechViewModel(),
          ),
        ],
        child: Builder(
          builder: (context) {
            final sttViewModel = context.read<SpeechViewModel>();
            final ttsViewModel = context.read<TextToSpeechViewModel>();

            return MyHomePage(
              sttViewModel: sttViewModel,
              ttsViewModel: ttsViewModel,
            );
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final SpeechViewModel sttViewModel;
  final TextToSpeechViewModel ttsViewModel;

  const MyHomePage({
    super.key,
    required this.sttViewModel,
    required this.ttsViewModel,
  });

  _handleOnTapMic() {
    if (sttViewModel.isRecording) {
      sttViewModel.stopRecording();
      return;
    }

    sttViewModel.startRecording();
  }

  _handleOnTapLanguageButton() {
    if (sttViewModel.isRecording) {
      return;
    }

    if (sttViewModel.language == Language.english) {
      sttViewModel.setLanguage(Language.korean);
    } else {
      sttViewModel.setLanguage(Language.english);
    }
  }

  _handleOnChangeTextField(String text) {
    ttsViewModel.setText(text);
  }

  _handleOnTapSpeakButton() {
    ttsViewModel.speak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  sttViewModel.text,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: sttViewModel.isRecording
                      ? null
                      : _handleOnTapLanguageButton,
                  child: Text(
                    sttViewModel.language == Language.korean
                        ? "영어로 변경"
                        : "한국어로 변경",
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextField(
                  onChanged: _handleOnChangeTextField,
                  decoration: const InputDecoration(
                    labelText: 'Text To Speak!',
                    hintText: 'Enter your email',
                    labelStyle: TextStyle(color: Colors.redAccent),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.redAccent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.redAccent),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed:
                      ttsViewModel.isLoading ? null : _handleOnTapSpeakButton,
                  child: Text(
                    ttsViewModel.isLoading ? "Stop Speaking" : "Tap to speak",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleOnTapMic,
        child: Icon(
          sttViewModel.isRecording ? Icons.mic_off : Icons.mic,
        ),
      ),
    );
  }
}
