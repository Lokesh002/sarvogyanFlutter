import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarvogyan/Screens/courseRegistrationLoadingScreen.dart';
import 'package:sarvogyan/Screens/courseSelected.dart';
import 'package:sarvogyan/Screens/enterMobileNoScreen.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sarvogyan/components/ReusableCard.dart';
import 'package:sarvogyan/components/ReusableButton.dart';
import 'package:sarvogyan/components/loginNetworking.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/utilities/userData.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  bool fromAllCourses = true;
  Login(this.fromAllCourses);
  @override
  _LoginState createState() => _LoginState();
}

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        SizedBox(
          width: 10,
        ),
        Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _LoginState extends State<Login> {
  LoginUserNetworking loginUserNetworking;
  SavedData savedData = SavedData();
  String email;
  String password;
  String login = 'Login';
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  clearTextInput() {
    emailcontroller.clear();
    passwordcontroller.clear();
  }

  @override
  void initState() {
    //Navigator.pushReplacementNamed(context, "/loadingScreen");
    signedIn = false;
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              Container(
                width: screenSize.screenWidth * 100,
                height: screenSize.screenHeight * 25,
                child: Image.asset(
                  "images/logo.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(
                height: screenSize.screenHeight * 4,
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Sign In",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: screenSize.screenHeight * 4,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenSize.screenWidth * 15,
                        right: screenSize.screenWidth * 15,
                        top: screenSize.screenHeight * 2),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.only(top: screenSize.screenHeight * 0),
                          child: TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Enter your email' : null,
                            controller: emailcontroller,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            onChanged: (name) {
                              this.email = name;
                              print(this.email);
                            },

                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: screenSize.screenHeight * 1.5,
                                fontFamily: "Montserrat"),
                            // focusNode: focusNode
                            decoration: InputDecoration(
                              hintText: "Email ID",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      screenSize.screenHeight * 2)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenSize.screenWidth * 15,
                        right: screenSize.screenWidth * 15,
                        top: screenSize.screenHeight * 2),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.only(top: screenSize.screenHeight * 0),
                          child: TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Enter your password' : null,
                            controller: passwordcontroller,
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            onChanged: (name) {
                              this.password = name;
                              print(this.password);
                            },

                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: screenSize.screenHeight * 1.5,
                                fontFamily: "Montserrat"),
                            // focusNode: focusNode

                            decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      screenSize.screenHeight * 2)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 4,
                  ),
                  Center(
                    child: ReusableButton(
                        height: screenSize.screenHeight * 6,
                        width: screenSize.screenWidth * 50,
                        content: login,
                        onPress: () async {
                          showAlertDialog(context);
                          setState(() {
                            login = 'Loading...';
                          });
                          print('hello $email & $password');
                          loginUserNetworking =
                              LoginUserNetworking(email, password);
                          int aT = await loginUserNetworking.postData();
                          if (aT == 200) {
                            //loggedIn = true;
                            Fluttertoast.showToast(msg: "Login Successfully");
                            if (widget.fromAllCourses) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                  context, '/homeScreen');
                            } else {
                              Navigator.pop(context);
                              //Navigator.pop(context);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                //Here DecodedData is a locally saved variable containing selected course data
                                return CourseSelected(DecodedData);
                                // Navigator.pop(context);
                              }));
                            }
                          } else {
                            setState(() {
                              //clearTextInput();
                              Fluttertoast.showToast(
                                  msg: "Please Check Internet Connection!");
                              setState(() {
                                login = 'Login';
                              });
                            });
                          }
                        }),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 2,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          //Here DecodedData is a locally savedvariable containing selected course data
                          return EnterMobileNoScreen(widget.fromAllCourses);
                        }));
                      },
                      child: Text("Login through Phone Number",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              fontSize: screenSize.screenHeight * 1.7),
                          textAlign: TextAlign.left),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 10,
                  ),
                  Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: screenSize.screenHeight * 3,
                          ),
                          Container(
                            width: double.infinity,
                            height: screenSize.screenHeight * 19,
                            color: Color(0xffdfdffa),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: screenSize.screenHeight * 5,
                                ),
//                                Text("Sign in With",
//                                    style: TextStyle(
//                                        color: Colors.black54,
//                                        fontWeight: FontWeight.normal,
//                                        fontFamily: "Montserrat",
//                                        fontStyle: FontStyle.normal,
//                                        fontSize: 14.0),
//                                    textAlign: TextAlign.left),
//                                SizedBox(
//                                  height: screenSize.screenHeight * 2,
//                                ),
//                                Row(
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                  children: <Widget>[
//                                    CircleAvatar(
//                                      child: CircleAvatar(
//                                        radius: screenSize.screenHeight * 2.5,
//                                        child: FaIcon(
//                                          FontAwesomeIcons.google,
//                                          color: Colors.white,
//                                        ),
//                                        backgroundColor:
//                                            Theme.of(context).primaryColor,
//                                      ),
//                                      radius: screenSize.screenHeight * 2.8,
//                                      backgroundColor: Colors.white,
//                                    ),
//                                    SizedBox(
//                                      width: screenSize.screenWidth * 2,
//                                    ),
//                                    Text("--or--",
//                                        style: TextStyle(
//                                            color: Colors.black54,
//                                            fontWeight: FontWeight.normal,
//                                            fontFamily: "Montserrat",
//                                            fontStyle: FontStyle.normal,
//                                            fontSize:
//                                                screenSize.screenHeight * 2),
//                                        textAlign: TextAlign.left),
//                                    SizedBox(
//                                      width: screenSize.screenWidth * 2,
//                                    ),
//                                    CircleAvatar(
//                                      radius: screenSize.screenHeight * 2.7,
//                                      backgroundColor: Colors.white,
//                                      child: Center(
//                                        child: FaIcon(
//                                          FontAwesomeIcons.facebook,
//                                          color: Theme.of(context).primaryColor,
//                                          size: screenSize.screenHeight * 5,
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
                                SizedBox(
                                  height: screenSize.screenWidth * 5,
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("New User? ",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Montserrat",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.left),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/registerUser');
                                        },
                                        child: Text("Sign Up ",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: "Montserrat",
                                                fontStyle: FontStyle.normal,
                                                fontSize:
                                                    screenSize.screenHeight *
                                                        1.7),
                                            textAlign: TextAlign.left),
                                      ),
                                      Text("Now ! ",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Montserrat",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.left),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: screenSize.screenHeight * 3 + 1,
                          child: CircleAvatar(
                            radius: screenSize.screenHeight * 3,
                            child: Text(
                              "OR",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Montserrat"),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              //)
            ]),
          ),
        ],
      ),
    );
  }
}
