import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_app/speech_api.g.dart';

import 'speech_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) {
          final viewModel = SpeechViewModel();
          // 채널 등록
          SpeechFlutterApi.setup(viewModel);
          return viewModel;
        },
        builder: (context, child) {
          final viewModel = context.watch<SpeechViewModel>();
          return MyHomePage(
            viewModel: viewModel,
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final SpeechViewModel viewModel;

  const MyHomePage({
    super.key,
    required this.viewModel,
  });

  handleOnTapMic() {
    if (viewModel.isRecording) {
      viewModel.stopRecording();
      return;
    }

    viewModel.startRecording();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              viewModel.text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleOnTapMic,
        child: Icon(
          viewModel.isRecording ? Icons.mic_off : Icons.mic,
        ),
      ),
    );
  }
}
