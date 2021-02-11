import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:athena_2/Components/chat_bubble.dart';
import 'package:athena_2/Models/chat_message.dart';
import 'package:athena_2/Services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<ChatMessage> chatMessage = [
    ChatMessage(message: "Hi I am athena, I can:", type: MessageType.Receiver),
    ChatMessage(
        message: "  - Provide you with a list of recommended area restaurants",
        type: MessageType.Receiver),
    ChatMessage(
        message:
            "  - Get you directions to the most frequently requested locations",
        type: MessageType.Receiver),
    ChatMessage(
        message: "  - Get you a copy of the folio for your stay",
        type: MessageType.Receiver),
  ];

  ScrollController _scrollController = new ScrollController();
  FlutterTts flutterTts = FlutterTts();

  stt.SpeechToText _speech;
  bool _isListening = false;
  // double _confidence = 1.0;
  bool initialized = false;

  @override
  void initState() {
    super.initState();

    initializeTts();
    _speech = stt.SpeechToText();
  }

  void initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);

    await flutterTts.speak('Hi I am Athena, I can: ' +
        'Provide you with a list of recommended area restaurants' +
        'Get you directions to the most frequently requested locations' +
        'Get you a copy of the folio for your stay');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Athena'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.78,
            child: ListView.builder(
              itemCount: chatMessage.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              // physics: NeverScrollableScrollPhysics(),
              controller: _scrollController,
              itemBuilder: (context, index) {
                return ChatBubble(
                  chatMessage: chatMessage[index],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(right: 30, bottom: 15),
              child: FloatingActionButton(
                onPressed: () async {
                  // sendSms();
                  _listen();
                },
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                ),
                backgroundColor: _isListening ? Colors.green : Colors.red,
                elevation: 0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _initialize() async {
    bool available = await _speech.initialize(onStatus: (val) {
      print('onStatus: $val');
      if (val == "notListening") setState(() => _isListening = false);
    }, onError: (val) {
      setState(() => _isListening = false);
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
        onResult: (val) {
          setState(() {
            print("***********" + val.recognizedWords);
            _isListening = false;

            if (val.recognizedWords != '') sendSms(val.recognizedWords);
          });
        },
        listenFor: Duration(minutes: 2),
        cancelOnError: false,
        partialResults: false,
      );
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void sendSms(String text) async {
    ChatMessage newMessage =
        ChatMessage(message: text, type: MessageType.Sender);
    setState(() {
      chatMessage.add(newMessage);
    });

    dynamic data = {"message": text, "sender": "id344"};
    dynamic reply = await API().postData(data);

    ChatMessage replyMessage =
        ChatMessage(message: reply, type: MessageType.Receiver);

    await flutterTts.speak(reply);
    setState(() {
      chatMessage.add(replyMessage);
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget typingIndicator() {
    return SizedBox(
      width: 250.0,
      child: TyperAnimatedTextKit(
        onTap: () {
          print("Tap Event");
        },
        text: [
          "...",
        ],
        textStyle: TextStyle(fontSize: 30.0, fontFamily: "Bobbers"),
        textAlign: TextAlign.start,
      ),
    );
  }
}
