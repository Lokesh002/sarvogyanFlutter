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

    //Checking Balance First
    http.Response response = await http.get(
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user',
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": accessToken
        });
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = convert.jsonDecode(data);
      if (decodedData['balance'] < cost) {
        print('Short of money by' + (cost - decodedData['balance']).toString());
        return "Please add money";
      } else {
        //Registering for course
        print('registering course for ' + accessToken);

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
          }

          updatebalance.update();
          return "Registered";
        } else {
          print('status code during registering: ${response1.statusCode}');
          return "Not able to register";
        }
      }
    } else {
      print('status code during registering: ${response.statusCode}');
      return "Not able to register";
    }
  }
}
