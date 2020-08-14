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
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              SizedBox(
                height: screenSize.screenHeight * 10,
              ),
              Container(
                height: screenSize.screenHeight * 20,
                child: SvgPicture.asset('svg/login.svg',
                    semanticsLabel: 'A red up arrow'),
              ),
              SizedBox(
                height: screenSize.screenHeight * 5,
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: screenSize.screenWidth * 10,
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenSize.screenHeight * 3.5,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: screenSize.screenWidth * 10,
                      ),
                      Text("Please enter your Email Address & Password",
                          style: const TextStyle(
                              color: const Color(0xff7f7f7f),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left)
                    ],
                  ),
                  SizedBox(
                    height: screenSize.screenWidth * 6,
                  ),
                  Center(
                    child: ReusableCard(
                      width: screenSize.screenWidth * 80,
                      height: screenSize.screenHeight * 6,
                      cardChild: Center(
                        child: TextField(
                          controller: emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (email) {
                            this.email = email;
                          },
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenSize.screenHeight * 1.5),
                          decoration: InputDecoration(
                            hintText: 'email@abc.com',
                            hintStyle: TextStyle(
                              color: Color(0xff4f4f4f),
                            ),
                            fillColor: Color(0xff009679),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(screenSize.screenHeight * 1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xfffafafa), width: 1.0),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(screenSize.screenHeight * 2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xfffafafa), width: 1.0),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(screenSize.screenHeight * 2)),
                            ),
                          ),
                        ),
                      ),
//
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenWidth * 6,
                  ),
                  Center(
                    child: ReusableCard(
                      height: screenSize.screenHeight * 6,
                      width: screenSize.screenWidth * 80,
                      cardChild: TextField(
                        controller: passwordcontroller,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        onChanged: (password) {
                          this.password = password;
                        },
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: screenSize.screenHeight * 1.5),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Color(0xff4f4f4f),
                          ),
                          fillColor: Color(0xff009679),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(screenSize.screenHeight * 1)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfffafafa), width: 1.0),
                            borderRadius: BorderRadius.all(
                                Radius.circular(screenSize.screenHeight * 2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xfffafafa), width: 1.0),
                            borderRadius: BorderRadius.all(
                                Radius.circular(screenSize.screenHeight * 2)),
                          ),
                        ),
                      ),
//
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenWidth * 6,
                  ),
                  Center(
                    child: ReusableButton(
                        height: screenSize.screenHeight * 8,
                        width: screenSize.screenWidth * 71,
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
                    height: screenSize.screenWidth * 10,
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
                              fontWeight: FontWeight.bold,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenWidth * 10,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, '/registerUser');
                      },
                      child: Text("New User? Sign Up Now !",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left),
                    ),
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
