import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sarvogyan/Screens/chooseColor.dart';
import 'package:sarvogyan/Screens/course/ListloadingScreen.dart';
import 'file:///D:/Projects/Flutter/sarvogyan/sarvogyan/lib/Screens/course/search/seachScreen.dart';
import 'package:sarvogyan/Screens/exams/examListLoadingScreen.dart';
import 'package:sarvogyan/Screens/homeScreen.dart';
import 'package:sarvogyan/Screens/profile/profile.dart';
import 'package:sarvogyan/Screens/search/filterLoadingScreen.dart';
import 'package:sarvogyan/Screens/splashScreen/splashScreen.dart';
import 'package:sarvogyan/Screens/userAuth/registerUser.dart';
import 'package:sarvogyan/components/courseTree.dart';

import 'package:sarvogyan/lists/theme.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Themes themes = Themes();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // getColr();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
//          primaryColor: primaryColor,
//          accentColor: accentColor,
          primaryColor: Color(0xfff09828),
          accentColor: Color(0xffffffff),
          backgroundColor: Colors.white),
      initialRoute: '/',
      themeMode: ThemeMode.light,
      routes: <String, WidgetBuilder>{
        '/': (context) => SplashScreen(),
        '/loadingScreen': (context) => ListLoadingScreen(),
        '/registerUser': (context) => RegisterUser(),
        '/profile': (context) => ProfileView(),
        '/filterLoadingScreen': (context) => FilterLoadingScreen(),
        '/ExamLoadingScreen': (context) => ExamListLoadingScreen(),
        '/changeColour': (context) => ChangeColour(),
        //'/enterOtp': (context) => EnterOtpScreen(),
        '/homeScreen': (context) => HomeScreen(),
        '/searchCourses': (context) => SearchScreen(),
      },
    );
  }
}
