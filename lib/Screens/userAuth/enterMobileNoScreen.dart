import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/course/courseRegistrationLoadingScreen.dart';
import 'package:sarvogyan/Screens/course/courseSelected.dart';
import 'package:sarvogyan/Screens/userAuth/enterOtpScreen.dart';
import 'package:sarvogyan/components/Networking/firebaseNetworking.dart';

import 'package:sarvogyan/components/phoneCheck.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/components/Cards/ReusableCard.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sarvogyan/components/loginPhoneNetworking.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/utilities/userData.dart';

class EnterMobileNoScreen extends StatefulWidget {
  final bool fromAllCourses;
  EnterMobileNoScreen(this.fromAllCourses);
  @override
  _EnterMobileNoScreenState createState() => _EnterMobileNoScreenState();
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

class _EnterMobileNoScreenState extends State<EnterMobileNoScreen> {
  String mobileNo;

  var _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();

    super.dispose();
  }

  void phoneCheck(String phone, BuildContext context) async {
    showAlertDialog(context);
    print('reached');
    PhoneCheck phoneCheck = PhoneCheck(phone);
    bool isPhoneVerified = await phoneCheck.check();
    print(isPhoneVerified.toString() + " phone verified");
    if (isPhoneVerified) {
      setState(() {
        button = 'Sending...';
      });
      print("sending OTP");

      loginUserThroughPhone('+91' + mobileNo, context);
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Please register first');
      Navigator.pushReplacementNamed(context, '/registerUser');
    }
  }

  Future<bool> loginUserThroughPhone(String phone, BuildContext context) {
    Future<bool> verified;
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        //autoRetrievedSmsCodeForTesting: ,
        phoneNumber: phone,
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: "Please Try Again");
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          print("opening OTP Screen");
          String code;
          print(widget.fromAllCourses);
          Navigator.pop(context);
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            //Here DecodedData is a locally saved variable containing selected course data
            return EnterOtpScreen(widget.fromAllCourses);
          })).then((value) {
            code = value;
          });

          if (code != null) {
            showAlertDialog(context);
            print(code);
            print('process flow');
            try {
              AuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: code);
              print('process flow');
              UserCredential result =
                  await _auth.signInWithCredential(credential);

              print('process flow');
              User user = result.user;
              if (user != null) {
                print('signed in with: ' + result.user.phoneNumber);
                var u = await user.getIdTokenResult();
                print(u.token);

                LoginPhoneNetworking loginPhoneNetworking =
                    LoginPhoneNetworking(phone: mobileNo, accessToken: u.token);
                print('sending data');
                int status = await loginPhoneNetworking.postData();
                if (status == 200) {
                  Fluttertoast.showToast(msg: "Login Successfully");
                  log(FirebaseAuth.instance.currentUser.uid);
                  //FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  signedIn = true;
                  if (widget.fromAllCourses) {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/homeScreen');
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      //Here DecodedData is a locally saved variable containing selected course data
                      return CourseSelected(DecodedData, previewData);
                    }));
                  }
                } else {
                  setState(() {
                    //clearTextInput();
                    Fluttertoast.showToast(
                        msg: "Please Check Internet Connection!");
                    print('LoginFailed');
                    setState(() {
                      button = 'Send OTP';
                    });
                  });
                }
              } else {
                print('ERROR');
              }
            } catch (e) {
              print(e);
              Navigator.of(context).pop();
              Fluttertoast.showToast(msg: "Error");
            }
          } else {
            setState(() {
              button = "Send OTP";
            });
            Fluttertoast.showToast(msg: "Please Enter OTP");
            print("code=null");
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
    return verified;
  }

  String button = "Send OTP";
  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            height: screenSize.screenHeight * 95,
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: screenSize.screenWidth * 100,
                      height: screenSize.screenHeight * 30,
                      child: Image.asset(
                        "images/logo.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(
                      height: screenSize.screenHeight * 3,
                    ),
                    Text(
                      "Enter Mobile Number",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: screenSize.screenHeight * 3.5,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: screenSize.screenHeight * 5,
                    ),
                    Center(
                      child: Container(
                        height: screenSize.screenHeight * 7,
                        width: screenSize.screenWidth * 80,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: screenSize.screenWidth * 15,
                              child: Text(
                                "  +91-   ",
                                style: TextStyle(
                                    fontSize: screenSize.screenHeight * 2),
                              ),
                            ),
                            Container(
                              width: screenSize.screenWidth * 65,
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.phone,
                                textAlign: TextAlign.start,
                                onChanged: (value) {
                                  mobileNo = value;
                                },
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: screenSize.screenHeight * 3),
                                decoration: InputDecoration(
                                  hintText: 'Enter Mobile No.',
                                  hintStyle: TextStyle(
                                      color: Color(0xff4f4f4f),
                                      fontSize: screenSize.screenHeight * 1.7),
                                  fillColor: Color(0xff009679),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenSize.screenHeight * 3,
                    ),
                    SizedBox(
                      height: screenSize.screenHeight * 3,
                    ),
                    Center(
                      child: ReusableButton(
                          onPress: () {
                            userPhoneNo = mobileNo;
                            setState(() {
                              button = 'Processing...';
                            });
                            if (mobileNo.length == 10) {
                              print('going to phone check');
                              phoneCheck(mobileNo, context);
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Enter Valid Phone No.');
                              button = 'Send OTP';
                            }
                          },
                          content: button,
                          height: screenSize.screenHeight * 8,
                          width: screenSize.screenWidth * 50),
                    ),
                  ],
                ),
              ]),
            )));
  }
}
