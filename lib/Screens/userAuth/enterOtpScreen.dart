import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/course/courseRegistrationLoadingScreen.dart';
import 'package:sarvogyan/components/firebaseAuthCall.dart';
import 'package:sarvogyan/components/loginPhoneNetworking.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/components/Cards/ReusableCard.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/utilities/userData.dart';
import 'package:sarvogyan/Screens/userAuth/enterMobileNoScreen.dart';
import 'package:quiver/async.dart';

class EnterOtpScreen extends StatefulWidget {
  final bool fromAllCourses;
  EnterOtpScreen(this.fromAllCourses);
  @override
  _EnterOtpScreenState createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  String otp;
  String timer;
  int _start;

  int _current;
  CountdownTimer countDownTimer;
  bool resendAllowed = false;

  var sub;
  void loginUser(String phone) {
    print("inside firebaseAuthClass");
    String code;
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential credential) async {},
        verificationFailed: (AuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          print("opening fire OTP Screen");
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            //Here DecodedData is a locally saved variable containing selected course data
            return EnterOtpScreen(widget.fromAllCourses);
          })).then((value) {
            code = value;
          });
          if (code != null) {
            print(code);
            Navigator.pop(context, code);
//          print('process fire flow');
//          try {
//            AuthCredential credential = PhoneAuthProvider.getCredential(
//                verificationId: verificationId, smsCode: code);
//            print('process fire flow');
//            AuthResult result = await _auth.signInWithCredential(credential);
//            print('process fire flow');
//            FirebaseUser user = result.user;
//            if (user != null) {
//              print('signed fire in with: ' + result.user.phoneNumber);
//              var u = await user.getIdToken();
//              print(u.token);
//              String phoneNo = phone.substring(3, phone.length);
//              LoginPhoneNetworking loginPhoneNetworking =
//                  LoginPhoneNetworking(phone: phoneNo, accessToken: u.token);
//              print('sending fire data');
//              int status = await loginPhoneNetworking.postData();
//              print(status);
//              FirebaseAuth.instance.signOut();
//              if (status == 200) {
//                print("successfully login");
//                Fluttertoast.showToast(msg: "Login Successfully");
//                print(widget.fromAllCourses);
//                if (widget.fromAllCourses) {
//                  if (this.mounted)
//                    Navigator.pushReplacementNamed(context, '/loadingScreen');
//                  else
//                    print("not mounted");
//                } else {
//                  if (this.mounted)
//                    Navigator.pushReplacement(context,
//                        MaterialPageRoute(builder: (context) {
//                      //Here DecodedData is a locally saved variable containing selected course data
//                      return CourseRegistrationLoadingScreen(
//                          DecodedData, false);
//                    }));
//                  else
//                    print("else not mounted");
//                }
//              } else {
//                //clearTextInput();
//                Fluttertoast.showToast(
//                    msg: "Please Check Internet Connection!");
//                print('LoginfireFailed');
//                print(status);
//              }
//            } else {
//              print('fireERROR');
//            }
//          } catch (e) {
//            print(e);
          } else {
            Fluttertoast.showToast(msg: "Please Enter OTP");
            print("code=null");
          }
        },
        codeAutoRetrievalTimeout: null);
  }

  void startTimer() {
    _current = 30;
    _start = 30;

    countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      if (this.mounted)
        setState(() {
          _current = _start - duration.elapsed.inSeconds;
        });
      else
        return;
    });
    if (this.mounted)
      sub.onDone(() {
        if (this.mounted) {
          print("Done");
          countDownTimer.cancel();
          setState(() {
            resendAllowed = true;
          });

          sub.cancel();
        }
      });
    else
      return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: Column(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: screenSize.screenHeight * 9.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: screenSize.screenWidth * 10,
                  ),
                  Text(
                    "Enter OTP",
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
                height: screenSize.screenHeight * 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("An OTP sent on",
                            style: const TextStyle(
                                color: const Color(0xff7f7f7f),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 14),
                            textAlign: TextAlign.left),
                        Text(" +91 " + userPhoneNo, //$mobileNo",
                            style: const TextStyle(
                                color: const Color(0xff4f4f4f),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontSize: 14),
                            textAlign: TextAlign.left),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text("Change",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0),
                          textAlign: TextAlign.left),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.screenHeight * 5,
              ),
              Center(
                child: ReusableCard(
                  height: screenSize.screenHeight * 7,
                  width: screenSize.screenWidth * 80,
                  cardChild: TextField(
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      otp = value;
                    },
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: screenSize.screenHeight * 3),
                    decoration: InputDecoration(
                      hintText: 'Enter OTP',
                      hintStyle: TextStyle(
                          color: Color(0xff4f4f4f),
                          fontSize: screenSize.screenHeight * 1.7),
                      fillColor: Color(0xff009679),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.screenHeight * 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (resendAllowed) {
                        loginUser('+91' + userPhoneNo);
                      }
                    },
                    child: Text("Resend OTP",
                        style: TextStyle(
                            color: resendAllowed
                                ? Theme.of(context).primaryColor
                                : Color(0xff7f7f7f),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  Text("| 00:" + _current.toString(), //$timer",
                      style: TextStyle(
                          color: resendAllowed
                              ? Color(0xff7f7f7f)
                              : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0),
                      textAlign: TextAlign.left),
                ],
              ),
              SizedBox(
                height: screenSize.screenHeight * 3,
              ),
              Center(
                child: ReusableButton(
                    onPress: () {
                      print("sending code" + otp);

                      Navigator.pop(context, otp);
                    },
                    content: "Verify OTP",
                    height: screenSize.screenHeight * 8,
                    width: screenSize.screenWidth * 71),
              ),
            ],
          ),
        ])));
  }
}
