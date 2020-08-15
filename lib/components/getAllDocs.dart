import 'package:sarvogyan/components/Networking.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/utilities/userData.dart';

class GetAllDocs {
  String url =
      "https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/document/all/student";

  Future<List<Docs>> getDocsList() async {
    List<Docs> docsList = List<Docs>();
    SavedData savedData = SavedData();
    authAccessToken = await savedData.getAccessToken();
    print(authAccessToken);
    http.Response response = await http.get('$url', headers: {
      "Content-Type": "application/json",
      "x-auth-token": authAccessToken
    });
    if (response.statusCode == 200) {
      var decodedData = await convert.jsonDecode(response.body);
      List data = decodedData;
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        Docs docs = Docs();
        docs.name = data[i]["name"];
        docs.link = data[i]["link"];
        print(data[i]["name"]);
        docsList.add(docs);
      }

      return docsList;
    }
    return null;
  }
}

class Docs {
  String name;
  String link;
}
