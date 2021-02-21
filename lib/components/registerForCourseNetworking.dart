import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sarvogyan/components/addCourseToSharedPref.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/components/updateBalance.dart';
import 'dart:convert' as convert;

class RegisterForCourseNetworking {
  String name;
  List<String> courseList = List<String>();
  var data;
  String email;
  String password;
  String phoneNo;
  String address;
  String age;
  String accessToken;
  String url =
      "https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/course/";

  SavedData savedData = SavedData();
  AddCoursesToSharedPref addCoursesToSharedPref = AddCoursesToSharedPref();
  RegisterForCourseNetworking(this.data);
  UpdateBalance updatebalance = UpdateBalance();
  Future register() async {
    String cId = data['id'];
    int cost = data['cost'];
    print("reached register function to get registration from");
    print('$url$cId');

    print('checking balance');
    accessToken = await savedData.getAccessToken();

    //Registering for course
    print('registering course for ' + accessToken);
    if (cost <= await savedData.getBalance() || cost == null) {
      http.Response response1 = await http.put(
        '$url$cId',
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": accessToken
        },
      );
      if (response1.statusCode == 200) {
        print("Successfully registered");
        bool x = await addCoursesToSharedPref.addCourses();
        if (x) {
          print("added Course to shared pref and course are: ");
          print(savedData.getCourses());
          if (cost != null) {
            int bal = await savedData.getBalance();
            bal = bal - cost;
            await savedData.setBalance(bal);
          }
        }

        // updatebalance.update();
        return "Registered";
      } else {
        print('status code during registering: ${response1.statusCode}');
        return "Not able to register";
      }
    } else {
      return 'Please add money';
    }
  }
}
