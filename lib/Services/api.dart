import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  getData() async {
    var response = await http.get(
        Uri.encodeFull("https://a490783114d1.ngrok.io/version"), //uri of api
        headers: {"Accept": "application/json"});

    Map<String, dynamic> data = jsonDecode(response.body);
    print(data); //Response from the api
  }

  postData(Map<String, String> data) async {
    var response = await http.post(
      Uri.encodeFull("https://a490783114d1.ngrok.io/webhooks/rest/webhook"),
      headers: {"Accept": "application/json"}, //uri of api
      body: jsonEncode(data),
    );

    // Map<String, dynamic> res = jsonDecode(response.body);
    print(response.body); //Response from the api
  }
}
