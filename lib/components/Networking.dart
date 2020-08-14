import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Networking {
  var url;

  Networking(
    this.url,
  );

  Future getData() async {
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = convert.jsonDecode(data);
      return decodedData;
    } else
      print(response.statusCode);
    return null;
  }
}
