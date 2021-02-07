import 'package:http/http.dart' as http;

import 'dart:convert' as convert;

import 'package:sarvogyan/components/Constants/constants.dart';

class Networking {
  String ip = ipAddress;

  Future getData(String url) async {
    String fullURL = ip + url;

    http.Response getResponse = await http.get(
      fullURL,
      headers: {"Content-Type": "application/json"},
    );

    if (getResponse.statusCode == 200) {
      String data = getResponse.body;
      var decodedData = convert.jsonDecode(data);
      return decodedData;
    } else {
      print(getResponse.statusCode);
    }
    return null;
  }

  Future postData(String url, var body) async {
    String fullURL = ip + url;
    http.Response postResponse = await http.post(fullURL,
        headers: {"Content-Type": "application/json"},
        body: convert.jsonEncode(body));

    if (postResponse.statusCode == 200) {
      String data = postResponse.body;
      var decodedData = convert.jsonDecode(data);
      return decodedData;
    } else {
      print(postResponse.statusCode);
    }
    return null;
  }

  Future deleteData(String url) async {
    String fullURL = ip + url;
    http.Response postResponse = await http
        .delete(fullURL, headers: {"Content-Type": "application/json"});

    if (postResponse.statusCode == 200) {
      String data = postResponse.body;
      var decodedData = convert.jsonDecode(data);
      return decodedData;
    } else {
      print(postResponse.statusCode);
    }
    return null;
  }
}
