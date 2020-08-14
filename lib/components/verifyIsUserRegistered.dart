import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:sarvogyan/utilities/sharedPref.dart';

class VerifyIsUserRegistered {
  var courseData;
  VerifyIsUserRegistered(this.courseData);
  SavedData savedData = SavedData();
  Future<bool> getVerificationStatus() async {
    print("getting verification status");
    List<String> courses = List<String>();
    bool isPresent = false;
    String UserAccessToken = await savedData.getAccessToken();
    http.Response response = await http.get(
      'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user',
      headers: {
        "Content-Type": "application/json",
        "x-auth-token": UserAccessToken
      },
    );

    if (response.statusCode == 200) {
      print("got user details. step1");
      var decodedUserData = await convert.jsonDecode(response.body);
      print('decodedUserData: $decodedUserData');
      List data = decodedUserData['courses'];
      print(courseData['id']);
      for (int i = 0; i < data.length; i++) {
        String a = data[i]['course'];
        if (courseData['id'] == a) {
          isPresent = true;
          print("its present");
          break;
        }
      }
      print('is present:' + isPresent.toString());
      return isPresent;
    } else {
      Fluttertoast.showToast(msg: 'Error ' + response.statusCode.toString());
    }
  }
}
