import 'package:sarvogyan/components/Networking.dart';

class CourseModel {
  Future<dynamic> getCourseDetails(String crsId) async {
    var url =
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/course/$crsId';
    Networking networking = Networking(url);
    var decodedData = await networking.getData();
    return decodedData;
  }

  Future<dynamic> getAllCourses() async {
    print('getting all courses');
    Networking networking = Networking(
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/course');

    var decodedData = await networking.getData();
    return decodedData;
  }

  Future<dynamic> getAllCategories() async {
    var url =
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/course/category';
    Networking networking = Networking(url);
    var decodedData = await networking.getData();
    return decodedData;
  }
}
