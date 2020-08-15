import 'package:shared_preferences/shared_preferences.dart';

class SavedData {
  setUserName(String name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setString('userName', name);
  }

  Future<String> getName() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getString('userName');
    if (name == null) {
      return null;
    } else
      return name;
  }

  setEmail(String name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setString('Email', name);
  }

  Future<String> getEmail() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getString('Email');
    if (name == null) {
      return null;
    } else
      return name;
  }

  setPhone(String name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setString('Phone', name);
  }

  Future<String> getPhone() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getString('Phone');
    if (name == null) {
      return null;
    } else
      return name;
  }

  setAddress(String name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setString('address', name);
  }

  Future<String> getAddress() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getString('address');
    if (name == null) {
      return null;
    } else
      return name;
  }

  setAge(String name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setString('Age', name);
  }

  Future<String> getAge() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getString('Age');
    if (name == null) {
      return null;
    } else
      return name;
  }

  setAccessToken(String name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setString('AccessToken', name);
  }

  Future<String> getAccessToken() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getString('AccessToken');
    if (name == null) {
      return null;
    } else
      return name;
  }

  setBalance(int name) async {
    final savedUserName = await SharedPreferences.getInstance();

    await savedUserName.setInt('Balance', name == null ? 0 : name);
  }

  Future<int> getBalance() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getInt('Balance');
    if (name == null) {
      return 0;
    } else
      return name;
  }

  setLoggedIn(bool name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setBool('LoggedIn', name);
  }

  Future<bool> getLoggedIn() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getBool('LoggedIn');
    if (name == null) {
      return false;
    } else
      return name;
  }

  setCourse(List<String> name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setStringList('courseList', name);
  }

  Future<List<String>> getCourses() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getStringList('courseList');
    if (name == null) {
      return null;
    } else
      return name;
  }

//To be coded for getting Image
  setProfileImage(String name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setString('photoURL', name);
  }

  Future<String> getProfileImage() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getString('photoURL');
    if (name == null) {
      return null;
    } else
      return name;
  }

  setPrimaryColor(int name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setInt('PRIMARY', name);
  }

  Future<int> getPrimaryColor() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getInt('PRIMARY');
    if (name == null) {
      return null;
    } else
      return name;
  }

  setAccentColor(int name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setInt('ACCENT', name);
  }

  Future<int> getAccentColor() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getInt('ACCENT');
    if (name == null) {
      return null;
    } else
      return name;
  }

  setUserSubsLevel(String name) async {
    final savedUserName = await SharedPreferences.getInstance();
    await savedUserName.setString('subscriptionLevel', name);
  }

  Future<String> getUserSubsLevel() async {
    final savedUserName = await SharedPreferences.getInstance();
    final name = savedUserName.getString('subscriptionLevel');
    if (name == null) {
      return null;
    } else
      return name;
  }
}
