import 'package:http/http.dart' as http;
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'dart:convert' as convert;

class PhoneCheck {
  String accessToken;
  SavedData savedData = SavedData();
  String phone;
  PhoneCheck(this.phone);

  Future check() async {
    print('$phone is phone no.');

    http.Response response1 = await http.post(
        "https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user/phoneCheck",
        headers: {"Content-Type": "application/json"},
        body: convert.jsonEncode({
          'phone': phone,
        }));

    if (response1.statusCode == 200) {
      print(response1.statusCode);
    } else {
      String data = response1.body;
      var decodedData = convert.jsonDecode(data);
      print(decodedData['msg']);
      if (decodedData['msg'] == "Phone number already in use") {
        return true;
      }
    }
    return false;
  }
}
