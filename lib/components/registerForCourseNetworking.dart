import 'package:firebase_analytics/firebase_analytics.dart';
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
  // String email;
  //String password;
//  String phoneNo;
  //String address;
  //String age;

  String getSubscription(String sub) {
    if (sub == 'a')
      return "Free Course";
    else if (sub == 'b')
      return "Basic Course";
    else if (sub == 'c')
      return "Premium Course";
    else
      return "Invalid Subscription Code";
  }

  String accessToken;
  String url =
      "https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/course/";

  SavedData savedData = SavedData();
  AddCoursesToSharedPref addCoursesToSharedPref = AddCoursesToSharedPref();
  RegisterForCourseNetworking(this.data);
  UpdateBalance updatebalance = UpdateBalance();
  Future register() async {
    String cId = data['id'];
    int cost = int.parse(data['cost'].toString());
    print("reached register function to get registration from");
    print('$url$cId');

    print('checking balance');
    accessToken = await savedData.getAccessToken();

    String uId = await savedData.getUserId();
    String name = await savedData.getName();

    //Registering for course
    print('registering course for ' + accessToken);
    if (cost == null || cost <= await savedData.getBalance()) {
      http.Response response1 = await http.put(
        '$url$cId',
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": accessToken
        },
      );

      if (response1.statusCode == 200) {
        print("Successfully registered");
        FirebaseAnalytics()
            .logEvent(name: 'Registered_for_course', parameters: {
          'CourseName': data['name'],
          'CourseId': data['id'],
          'CourseType': getSubscription(data['subscription']),
          'Cost': data['cost'].toString(),
          'UserID': uId,
          'UserName': name
        });
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
