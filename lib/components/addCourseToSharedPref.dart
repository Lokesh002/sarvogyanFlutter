import "package:http/http.dart" as http;
import "dart:convert" as convert;
import "package:sarvogyan/utilities/sharedPref.dart";

class AddCoursesToSharedPref {
  AddCoursesToSharedPref();
  SavedData savedData = SavedData();
  Future<bool> addCourses() async {
    List<String> courses = List<String>();
    bool isPresent = false;
    String userAccessToken = await savedData.getAccessToken();
    http.Response response = await http.get(
      'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user',
      headers: {
        "Content-Type": "application/json",
        "x-auth-token": userAccessToken
      },
    );

    if (response.statusCode == 200) {
      var decodedUserData = await convert.jsonDecode(response.body);
      print('decodedUserData: $decodedUserData');
      List data = decodedUserData['courses'];

      for (int i = 0; i < data.length; i++) {
        String a = data[i]['course'];
        courses.add(a);
      }
      print('course variable contains');
      print(courses);
      await savedData.setCourse(courses);
      return true;
    } else {
      print("Not able to get user data in addtoSharePref" +
          response.statusCode.toString());
    }
    return false;
  }
}
