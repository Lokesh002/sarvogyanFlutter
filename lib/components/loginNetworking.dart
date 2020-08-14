import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'dart:convert' as convert;
import 'package:sarvogyan/utilities/userData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUserNetworking {
  String email;
  String password;
  List<String> courses = List<String>();
  String accessToken;
  SavedData savedData = SavedData();

  LoginUserNetworking(this.email, this.password);

  String url =
      "https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user/";

  Future postData() async {
    http.Response response;

    print('$email and $password');

    http.Response response1 = await http.post(
        "https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user/auth/user",
        headers: {"Content-Type": "application/json"},
        body: convert.jsonEncode({
          'email': email,
          'password': password,
        }));

    if (response1.statusCode == 200) {
      String data = response1.body;
      var decodedData = convert.jsonDecode(data);
      accessToken = decodedData["token"];
      print("access token: $accessToken");
      authAccessToken = accessToken;
      print('access token is: $authAccessToken');
      response = await http.get(
          'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user',
          headers: {
            "Content-Type": "application/json",
            "x-auth-token": authAccessToken
          });
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = convert.jsonDecode(data);
        print(decodedData);
        await savedData.setAccessToken(accessToken);
        await savedData.setUserName(decodedData["name"]);
        await savedData.setAddress(decodedData["address"]);
        await savedData.setAge(decodedData["age"]);
        await savedData.setPhone(decodedData["phone"]);
        print(await savedData.getPhone());
        await savedData.setEmail(decodedData["email"]);
        await savedData.setUserSubsLevel(decodedData["subscription"]);
        print(await savedData.getUserSubsLevel());
        List dt = decodedData['courses'];
        for (int i = 0; i < dt.length; i++) {
          String a = dt[i]['course'];
          courses.add(a);
        }
        await savedData.setCourse(courses);
        if (decodedData['balance'] != null) {
          await savedData.setBalance(decodedData['balance']);
          print(await savedData.getBalance());
        } else {
          await savedData.setBalance(0);
          print(await savedData.getBalance());
        }
        if (decodedData.containsKey('picture')) {
          await savedData.setProfileImage(decodedData['picture']);
        }
        await savedData.setLoggedIn(true);
        signedIn = true;
        return response.statusCode;
      } else
        print(response.statusCode);
    } else {
      print('error ${response1.statusCode}');
    }
  }
}
