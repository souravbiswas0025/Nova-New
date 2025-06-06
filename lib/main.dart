import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(NovaApp());
}

class NovaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nova AI Assistant',
      theme: ThemeData.dark(),
      home: NovaHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NovaHome extends StatefulWidget {
  @override
  _NovaHomeState createState() => _NovaHomeState();
}

class _NovaHomeState extends State<NovaHome> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() {
            _spokenText = result.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nova")),
      body: Center(
        child: Text(
          _spokenText.isEmpty ? "Say something..." : _spokenText,
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}

