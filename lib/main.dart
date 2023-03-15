import 'package:text_to_speech/text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'talkgpt',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpeechToText _speechToText = SpeechToText();
  TextToSpeech _textToSpeech = TextToSpeech();
  bool _speechEnabled = false;
  String _lastWords = '';
  int cnt = 0;
  int cnt1 = 0;
  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _startSpeaking() async{
    _textToSpeech.speak(_lastWords);
  }

  void _stopSpeaking() async{
    _textToSpeech.pause();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             Spacer(),
             Expanded(
               child: Column(
                   children:[
                   const Text(
                      'Push the button to start talking',
                    ),
                    FloatingActionButton(
                      onPressed:cnt%2==1 ? _startListening : _stopListening,
                      child: Icon(_speechToText.isNotListening ? Icons.mic : Icons.mic_off)
                    ),// This trailing comm
                  ]
              )
             ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                  _speechToText.isListening
                      ? _lastWords
                  // If listening isn't active but could be tell the user
                  // how to start it, otherwise indicate that speech
                  // recognition is not yet ready or not supported on
                  // the target device
                      : _speechEnabled
                      ? 'Listening to speech and interpreting...'
                      : '-----Speech not available------',
                ),
              ),
            ),
            FloatingActionButton(
                onPressed: cnt1%2==1 ? _startSpeaking : _stopSpeaking,
                child: Icon(cnt1%2==1 ? Icons.stop : Icons.play_arrow)
            ), // This trailing comma makes auto-formatting nicer for build methods.
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                    cnt1%2==0
                      ? 'Tap to start listening to chatGPT'
                      : '',
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
