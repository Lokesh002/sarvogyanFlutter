import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/course/courseRegistrationLoadingScreen.dart';
import 'package:sarvogyan/Screens/userAuth/enterOtpScreen.dart';
import 'package:sarvogyan/components/loginPhoneNetworking.dart';
import 'package:sarvogyan/utilities/userData.dart';

class FirebseAuthCall {
  bool fromAllCourses;
  FirebseAuthCall(this.fromAllCourses);

  void loginUser(String phone, context) {
    print("inside firebaseAuthClass");
    String code;
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
//
        },
        verificationFailed: (AuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          print("opening fire OTP Screen");
          await Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            //Here DecodedData is a locally saved variable containing selected course data
            return EnterOtpScreen(fromAllCourses);
          })).then((value) {
            code = value;
          });

          print(code);
          print('process fire flow');
          try {
            AuthCredential credential = PhoneAuthProvider.getCredential(
                verificationId: verificationId, smsCode: code);
            print('process fire flow');
            AuthResult result = await _auth.signInWithCredential(credential);
            print('process fire flow');
            FirebaseUser user = result.user;
            if (user != null) {
              print('signed fire in with: ' + result.user.phoneNumber);
              var u = await user.getIdToken();
              print(u.token);
              String phoneNo = phone.substring(3, phone.length);
              LoginPhoneNetworking loginPhoneNetworking =
                  LoginPhoneNetworking(phone: phoneNo, accessToken: u.token);
              print('sending fire data');
              int status = await loginPhoneNetworking.postData();
              print(status);
              FirebaseAuth.instance.signOut();
              if (status == 200) {
                print("successfully login");
                Fluttertoast.showToast(msg: "Login Successfully");
                print(fromAllCourses);
                if (fromAllCourses) {
                  Navigator.pushReplacementNamed(context, '/loadingScreen');
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    //Here DecodedData is a locally saved variable containing selected course data
                    return CourseRegistrationLoadingScreen(DecodedData, false);
                  }));
                }
              } else {
                //clearTextInput();
                Fluttertoast.showToast(
                    msg: "Please Check Internet Connection!");
                print('LoginfireFailed');
                print(status);
              }
            } else {
              print('fireERROR');
            }
          } catch (e) {
            print(e);
          }
        },
        codeAutoRetrievalTimeout: null);
  }
}
