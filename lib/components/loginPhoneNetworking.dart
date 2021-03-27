import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'dart:convert' as convert;
import 'package:sarvogyan/utilities/userData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPhoneNetworking {
  String phone;
  List<String> courses = List<String>();
  String accessToken;
  SavedData savedData = SavedData();

  LoginPhoneNetworking({this.phone, this.accessToken});

  String url =
      "https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user/";

  Future postData() async {
    http.Response response;

    print('$phone');

    http.Response response1 = await http.post(
        "https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user/auth/user",
        headers: {"Content-Type": "application/json"},
        body: convert.jsonEncode({
          'phone': phone,
          'token': accessToken,
        }));

    if (response1.statusCode == 200) {
      String data = response1.body;
      var decodedData = convert.jsonDecode(data);
      accessToken = decodedData["token"];
      print("access token: $accessToken");
      authAccessToken = accessToken;
      //print('access token is: $authAccessToken');
      response = await http.get(
          'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user',
          headers: {
            "Content-Type": "application/json",
            "x-auth-token": authAccessToken
          });

      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = convert.jsonDecode(data);
        print("decoded user data: " + decodedData.toString());
        print(decodedData["subscription"]);
        await savedData.setLoggedIn(true);
        await savedData.setUserSubsLevel(decodedData['subscription']);
        await savedData.setAccessToken(accessToken);
        await savedData.setUserName(decodedData["name"]);
        await savedData.setAddress(decodedData["address"]);
        await savedData.setAge(decodedData["age"]);
        await savedData.setPhone(decodedData["phone"]);
        await savedData.setUserId(decodedData["id"]);
        await savedData.setTag(decodedData['tag']);
        if (decodedData["isStudent"] == null ||
            decodedData["isStudent"] == false) {
          await savedData.setIsStudent(decodedData["isStudent"]);
          await savedData.setBoard(null);
          await savedData.setClass(null);
        } else {
          await savedData.setIsStudent(decodedData["isStudent"]);
          await savedData.setBoard(decodedData["board"]);
          await savedData.setClass(decodedData["studentClass"]);
        }

        await savedData.setEmail(decodedData["email"]);

        print(await savedData.getUserSubsLevel());
        print(await savedData.getAccessToken());
        print(await savedData.getName());
        print(await savedData.getAddress());
        print(await savedData.getAge());
        print(await savedData.getPhone());
        print(await savedData.getIsStudent());
        print(await savedData.getBoard());
        print(await savedData.getClass());

        List dt = decodedData['courses'];
        for (int i = 0; i < dt.length; i++) {
          String a = dt[i]['course'];
          courses.add(a);
        }
        await savedData.setCourse(courses);

        if (decodedData['balance'] != null) {
          await savedData.setBalance(
              decodedData['balance'] == null ? 0 : decodedData['balance']);
          print(await savedData.getBalance());
        } else {
          await savedData.setBalance(0);
          print(await savedData.getBalance());
        }
        if (decodedData.containsKey('picture')) {
          await savedData.setProfileImage(decodedData['picture']);
        }
        signedIn = true;
        await savedData.setLoggedIn(true);
        return response.statusCode;
      } else
        print("printing eror 1 " + response.statusCode.toString());
    } else {
      print('error ${response1.statusCode}');
    }
  }
}
