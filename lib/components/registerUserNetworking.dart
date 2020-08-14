import 'package:http/http.dart' as http;
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'dart:convert' as convert;

class RegisterUserNetworking {
  String name;
  String email;
  String password;
  String phoneNo;
  String address;
  String age;
  String accessToken;
  String FirebaseAccessToken;
  RegisterUserNetworking(this.name, this.email, this.password, this.phoneNo,
      this.address, this.age, this.FirebaseAccessToken);

  String url =
      "http://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user";

  Future postData() async {
    http.Response response;
    SavedData savedData = SavedData();
    http.Response response1 = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: convert.jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'address': address,
          'phone': phoneNo,
          'age': age,
          'id': FirebaseAccessToken,
        }));

    if (response1.statusCode == 200) {
      http.Response response = await http.post("$url/auth/user",
          headers: {"Content-Type": "application/json"},
          body: convert.jsonEncode({
            "email": email,
            "password": password,
          }));
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = convert.jsonDecode(data);
        accessToken = decodedData["msg"];
        print("msg: $accessToken");

        print(
            "the details are: $name has $email and $phoneNo with age $age and address: $address");
        return response.statusCode;
      } else
        print(response.statusCode);
    } else {
      print('status code: ${response1.statusCode}');
    }
  }
}
