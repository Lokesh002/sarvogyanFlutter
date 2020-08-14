import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sarvogyan/Screens/chooseColor.dart';

import 'package:sarvogyan/Screens/enterMobileNoScreen.dart';
import 'package:sarvogyan/Screens/filterLoadingScreen.dart';
import 'package:sarvogyan/Screens/homeScreen.dart';
import 'package:sarvogyan/Screens/splashScreen.dart';
import 'package:sarvogyan/Screens/registerUser.dart';

import 'package:sarvogyan/Screens/profile.dart';
import 'package:sarvogyan/Screens/ListloadingScreen.dart';
import 'package:sarvogyan/Screens/examListLoadingScreen.dart';
import 'package:sarvogyan/Screens/enterOtpScreen.dart';
import 'package:sarvogyan/lists/theme.dart';

void main() {
  runApp(new MyApp());
}
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  Themes themes = Themes();
//  getColr() async {
//    await themes.getColor();
//  @override
//  Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitDown,
//    ]);
//    getColr();
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//          primaryColor: themes.primaryColor,
//          accentColor: themes.accentColor,
////          primaryColor: Color(0xffff6720),
////          accentColor: Color(0xffffe84f),
//          backgroundColor: Colors.white),
//      initialRoute: '/',
//      themeMode: ThemeMode.light,
//      routes: <String, WidgetBuilder>{
//        '/': (context) => SplashScreen(),
//        '/loadingScreen': (context) => ListLoadingScreen(),
//        '/registerUser': (context) => RegisterUser(),
//        '/profile': (context) => ProfileView(),
//        '/filterLoadingScreen': (context) => FilterLoadingScreen(),
//        '/ExamLoadingScreen': (context) => ExamListLoadingScreen(),
//        '/changeColour': (context) => ChangeColour(),
//        //'/enterOtp': (context) => EnterOtpScreen(),
//      },
//    );
//  }
//}
//

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Themes themes = Themes();

//  getColr() {
//    themes.getColor();
//  }

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
      },
    );
  }
}
