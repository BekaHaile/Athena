

class SpeechToText {
  bool initialized;
  // stt.SpeechToText _speech;

  // Future<bool> _initialize() async {
  //   bool available = await _speech.initialize(onStatus: (val) {
  //     print('onStatus: $val');
  //   }, onError: (val) {
  //     print('onError: $val');
  //   });
  //   initialized = true;
  //   return available;
  // }

  // void _listen() async {
  //   bool _isListening = false;
  //   if (!initialized) {
  //     if (!await _initialize()) print('error initializing');
  //   }
  //   if (!_isListening) {
  //     // setState(() => _isListening = true);
  //     _speech.listen(
  //         // onResult: (val) => setState(() {
  //         //       if (val.recognizedWords == 'Hello Siri') {
  //         //         _text = val.recognizedWords;
  //         //         _isListening = false;
  //         //       }
  //         //     }),
  //         listenFor: Duration(minutes: 2),
  //         cancelOnError: false);
  //   } else {
  //     _speech.stop();
  //   }
  // }
}
