import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'dart:convert' as convert;

class FilteredListNetworking {
  String selectedCategory;

  String accessToken;
  SavedData savedData = SavedData();

  FilteredListNetworking(this.selectedCategory);

  Future postData() async {
    print(' $selectedCategory');

    http.Response response1 = await http.post(
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/course/category',
        headers: {"Content-Type": "application/json"},
        body: convert.jsonEncode({'category': selectedCategory}));
    print("success");
    if (response1.statusCode == 200) {
      String data = response1.body;
      print("success2");
      var decodedData = convert.jsonDecode(data);
      return decodedData;
    } else {
      print('Status code for filtered list is ${response1.statusCode}');
      String data = response1.body;
      print("failure");
      var decodedData = convert.jsonDecode(data);
      Fluttertoast.showToast(msg: decodedData['msg']);
    }
  }
}
