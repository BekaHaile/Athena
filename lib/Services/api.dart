import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  getData() async {
    var response = await http.get(
        Uri.encodeFull("https://1a0e6649cd1d.ngrok.io/version"), //uri of api
        headers: {"Accept": "application/json"});

    Map<String, dynamic> data = jsonDecode(response.body);
    print(data); //Response from the api
  }

  postData(dynamic data) async {
    var response;
    try {
      response = await http.post(
        Uri.encodeFull(
            "https://a9933e0a94ee.ngrok.io/webhooks/rest/webhook"), //uri of api
        headers: {
          "Accept": "application/json; charset=UTF-8",
        },
        body: jsonEncode(data),
      );
    } catch (e) {
      print(e + 'has occured ****');
    }

    print(response.body + "${response.body.length}");
    if (response.body.length > 2) {
      Map<String, dynamic> res = jsonDecode(response.body)[0];
      if (response.body[0] == "[") print(res['text']); //Response from the api
      return res['text'];
    } else {
      return "Coudln't understand you, sorry";
    }
  }
}
