import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AthenaHome extends StatefulWidget {
  @override
  _AthenaHomeState createState() => _AthenaHomeState();
}

class _AthenaHomeState extends State<AthenaHome> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  double _confidence = 1.0;
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.asset(
                'assets/athen.gif',
                width: MediaQuery.of(context).size.width * 0.4,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Hello cherished Guest, I am Athena your virtual concierge',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Text(
            'You can use me by saying "Hello Athena"',
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/chatDetail');
          },
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ],
    );
  }
}
