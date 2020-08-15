import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:sarvogyan/utilities/sharedPref.dart';

class UpdateBalance {
  String acsTkn;
  SavedData savedData = SavedData();

  void update() async {
    acsTkn = await savedData.getAccessToken();

    http.Response response2 = await http.get(
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user',
        headers: {"Content-Type": "application/json", "x-auth-token": acsTkn});
    if (response2.statusCode == 200) {
      var data = response2.body;
      var decodedData = convert.jsonDecode(data);
      savedData.setBalance(
          decodedData['balance'] == null ? 0 : decodedData['balance']);
      print("New balance: " + decodedData['balance'] == null
          ? 0
          : decodedData['balance'].toString());
    } else {
      print(response2.statusCode);
    }
  }
}
