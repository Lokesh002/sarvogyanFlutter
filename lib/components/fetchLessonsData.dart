import 'package:sarvogyan/components/Networking.dart';
import 'package:http/http.dart' as http;
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'dart:convert' as convert;

class FetchLessons {
  var courseData;
  FetchLessons(this.courseData);
  Future<List<Lessons>> fetch() async {
    Map cData = courseData;
    List<Lessons> allLessons = List<Lessons>();
    SavedData savedData = SavedData();
    String acsTkn = await savedData.getAccessToken();

    String url =
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/course/';
    print('sending request');
    http.Response response = await http.get(
      '$url${cData['id']}/details/student',
      headers: {"Content-Type": "application/json", "x-auth-token": acsTkn},
    );
    if (response.statusCode == 200) {
      var data = response.body;

      var decDataLesson = convert.jsonDecode(data);
      print('got data');
      List lesson = decDataLesson['lessons'];

      for (int i = 0; i < lesson.length; i++) {
        Lessons lessons = Lessons();

        lessons.lessonCourseId = lesson[i]['course_id'];
        lessons.lessonId = lesson[i]['id'];

        lessons.lessonName = lesson[i]['name'];
        lessons.lessonTeacher = lesson[i]['teacher'];
        lessons.lessonDesc = lesson[i]['description'];
        List lParts = lesson[i]['parts'];
        for (int j = 0; j < lParts.length; j++) {
          Parts parts = Parts();

          parts.partName = lParts[j]['name'];
          parts.partId = lParts[j]['part_id'];

          parts.partType = lParts[j]['type'];
          parts.partContent = lParts[j]['content'];
          parts.partLessonId = lParts[j]['lesson_id'];

          lessons.lessonParts.add(parts);
        }

        allLessons.add(lessons);
      }

      print(allLessons.length);
      print('data used');
      print(decDataLesson);
    } else {
      print(response.statusCode);
    }

    return allLessons;
  }
}

class Parts {
  String partContent;
  String partName;
  String partLessonId;
  String partType;
  String partId;
}

class Lessons {
  String lessonTeacher;
  String lessonName;
  String lessonCourseId;
  String lessonDesc;
  String lessonId;
  List<Parts> lessonParts = List<Parts>();
}
