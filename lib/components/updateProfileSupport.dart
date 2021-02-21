import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:sarvogyan/utilities/sharedPref.dart';

class UpdateProfileSave {
  String name;
  String address;
  String age;
  bool isStudent;
  String board;
  String studentClass;
  String tag;
  String accessTkn;
  SavedData savedData = SavedData();
  UpdateProfileSave(
      {this.name,
      this.address,
      this.age,
      this.board,
      this.tag,
      this.studentClass,
      this.isStudent});
  int balance;
  Future<bool> updateProfile() async {
    accessTkn = await savedData.getAccessToken();
    balance = await savedData.getBalance();

    String subs = await savedData.getUserSubsLevel();
    print(board);
    print(studentClass);
    if (board != null || studentClass != null) {
      isStudent = true;
    }

    try {
      print(
          "Updating profile of $name of $address and $age and $board and $studentClass and accssTkn: $accessTkn and $balance");
      http.Response response = await http.post(
          "http://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user/updateProfile",
          headers: {
            "x-auth-token": accessTkn,
            "Content-Type": "application/json"
          },
          body: convert.jsonEncode({
            "address": this.address,
            "age": this.age,
            "balance": this.balance,
            "board": this.board,
            "tag": this.tag == null ? await savedData.getTag() : tag,
            "isStudent": this.isStudent ? 'yes' : 'no',
            "name": this.name,
            "studentClass": this.studentClass,
            "subscription": subs
          }));
      if (response.statusCode == 200) {
        print("Updated profile");
        var decodedData = convert.jsonDecode(response.body);
        print(decodedData);
        await savedData.setUserName(name);
        await savedData.setAge(age);
        await savedData.setClass(studentClass);
        await savedData.setAddress(address);
        await savedData.setBoard(board);
        await savedData.setIsStudent(isStudent ? 'yes' : 'no');
        return true;
      } else {
        print("problem in updating profile. post request sending error");
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}
