
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  String currentText = '';
  double _confidence = 1.0;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Column(
            children: [
              Text(
                _text,
                style: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: FlatButton(
                  child: Text(
                    _isListening ? 'listening' : 'not listening',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {},
                  color: _isListening ? Colors.green : Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _initialize() async {
    bool available = await _speech.initialize(onStatus: (val) {
      print('onStatus: $val');
      if(currentText == 'Hello Siri'){
          _isListening = false;
      }
      else if (val == 'notListening' && currentText == '') {
        setState(() {
          _isListening = false;
        });
        Future.delayed(const Duration(milliseconds: 700), () {
          print('restarting after a delay');
          _listen();
        });
      } else if (val == 'notListening' && currentText != '') {
        currentText = '';
      }
    }, onError: (val) {
      setState(() {
        _isListening = false;
      });
      print('onError: $val');
    });
    initialized = true;
    return available;
  }

  void _listen() async {
    if (!initialized) {
      if (!await _initialize()) print('error initializing');
    }
    if (!_isListening) {
      setState(() => _isListening = true);
      _speech.listen(
          onResult: (val) => setState(() {
                if (val.recognizedWords == 'Hello Siri') {
                  _text = val.recognizedWords;
                  currentText = val.recognizedWords;
                  _isListening = false;
                  if (val.hasConfidenceRating && val.confidence > 0) {
                    _confidence = val.confidence;
                  }
                } else {
                  setState(() {
                    _text =
                        'This is detected but skipped = ' + val.recognizedWords;
                  });
                  _isListening = false;
                  _listen();
                }
              }),
          listenFor: Duration(minutes: 2),
          cancelOnError: false);
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}