import 'package:firebase_analytics/firebase_analytics.dart';
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
  String UId;
  String FirebaseAccessToken;
  String tag;
  String isStudent;
  RegisterUserNetworking(
      this.name,
      this.email,
      this.password,
      this.phoneNo,
      this.address,
      this.age,
      this.UId,
      this.FirebaseAccessToken,
      this.tag,
      this.isStudent);

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
          'id': UId,
          'token': FirebaseAccessToken,
          'tag': tag,
          'isStudent': isStudent
        }));

    if (response1.statusCode == 200) {
      http.Response response = await http.post("$url/auth/user",
          headers: {"Content-Type": "application/json"},
          body: convert.jsonEncode({
            "email": email,
            "password": password,
            "token": FirebaseAccessToken,
          }));

      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = convert.jsonDecode(data);
        accessToken = decodedData["msg"];
        print("msg: $accessToken");

        FirebaseAnalytics().logEvent(name: 'User Registered', parameters: {
          'name': name,
          'email': email,
          'address': address,
          'phone': phoneNo,
          'age': age,
          'id': UId,
          'tag': tag,
          'isStudent': isStudent
        });
        print(
            "the details are: $name has $email and $phoneNo with age $age and address: $address");
        return response.statusCode;
      } else
        print("register error code: " + response.statusCode.toString());
      return 400;
    } else {
      print('status code of registerNetworking: ${response1.statusCode}');
      return 400;
    }
  }

  Future registerThroughPhone() async {
    http.Response response;
    SavedData savedData = SavedData();
    http.Response response1 = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: convert.jsonEncode({
          'name': name,
          'address': address,
          'phone': phoneNo,
          'age': age,
          'id': UId,
          'token': FirebaseAccessToken,
          'tag': tag,
          'isStudent': isStudent
        }));

    if (response1.statusCode == 200) {
      http.Response response = await http.post("$url/auth/user",
          headers: {"Content-Type": "application/json"},
          body: convert.jsonEncode({
            "email": email,
            "password": password,
            "token": FirebaseAccessToken,
          }));
      if (response.statusCode == 200) {
        String data = response.body;

        var decodedData = convert.jsonDecode(data);
        accessToken = decodedData["msg"];
        print("msg: $accessToken");

        FirebaseAnalytics()
            .logEvent(name: 'User Registered Through Phone', parameters: {
          'name': name,
          'address': address,
          'phone': phoneNo,
          'age': age,
          'id': UId,
          'tag': tag,
          'isStudent': isStudent
        });
        print(
            "the details are: $name has $email and $phoneNo with age $age and address: $address");
        return response.statusCode;
      } else
        print("register error code: " + response.statusCode.toString());
      return 400;
    } else {
      print('status code of registerNetworking: ${response1.statusCode}');
      return 400;
    }
  }
}
