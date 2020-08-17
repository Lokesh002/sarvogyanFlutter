import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/login.dart';
import 'package:sarvogyan/components/loginPhoneNetworking.dart';
import 'package:sarvogyan/components/phoneCheck.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sarvogyan/components/ReusableCard.dart';
import 'package:sarvogyan/components/ReusableButton.dart';
import 'package:sarvogyan/components/registerUserNetworking.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor,
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

class _RegisterUserState extends State<RegisterUser> {
  String smsOTP;
  String verificationId;
  String errorMessage = '';

  FirebaseAuth auth = FirebaseAuth.instance;
  AuthResult result;

  bool age1selected = false;
  bool age2selected = false;
  bool age3selected = false;
  String error = '';
  String name;
  String email;
  String password;
  String phoneNo;
  String address;
  String age;
  String accessToken;
  bool registeredSuccess = false;

  final _formKey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final addresscontroller = TextEditingController();
  final phoneNocontroller = TextEditingController();

  clearTextInput() {
    namecontroller.clear();
    emailcontroller.clear();
    passwordcontroller.clear();
    phoneNocontroller.clear();
    addresscontroller.clear();
  }

  RegisterUserNetworking registerUserNetworking;
  @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    phoneNocontroller.dispose();
    addresscontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);

    Icon age1 = age1selected
        ? Icon(
            Icons.check_circle,
            size: screenSize.screenHeight * 2,
            color: Theme.of(context).primaryColor,
          )
        : Icon(
            Icons.check_circle_outline,
            size: screenSize.screenHeight * 2,
            color: Theme.of(context).primaryColor,
          );
    Icon age2 = age2selected
        ? Icon(
            Icons.check_circle,
            size: screenSize.screenHeight * 2,
            color: Theme.of(context).primaryColor,
          )
        : Icon(
            Icons.check_circle_outline,
            size: screenSize.screenHeight * 2,
            color: Theme.of(context).primaryColor,
          );
    Icon age3 = age3selected
        ? Icon(
            Icons.check_circle,
            size: screenSize.screenHeight * 2,
            color: Theme.of(context).primaryColor,
          )
        : Icon(
            Icons.check_circle_outline,
            size: screenSize.screenHeight * 2,
            color: Theme.of(context).primaryColor,
          );

    return Scaffold(
      resizeToAvoidBottomPadding: true,
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
                height: screenSize.screenHeight * 2,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: screenSize.screenHeight * 3.5,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 2,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[]),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenSize.screenHeight * 5,
                              right: screenSize.screenHeight * 5,
                              top: screenSize.screenHeight * 2),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: screenSize.screenHeight * 2),
                                child: TextFormField(
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter your name' : null,
                                  controller: namecontroller,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.start,
                                  onChanged: (name) {
                                    this.name = name;
                                    print(this.name);
                                  },

                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: screenSize.screenHeight * 2),
                                  // focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText: "Name",
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
                              left: screenSize.screenHeight * 5,
                              right: screenSize.screenHeight * 5,
                              top: screenSize.screenHeight * 2),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an Email' : null,
                                  controller: emailcontroller,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.start,
                                  onChanged: (name) {
                                    this.email = name;
                                    print(this.email);
                                  },
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: screenSize.screenHeight * 2),
                                  // focusNode: focusNode,

                                  decoration: InputDecoration(
                                    hintText: "Email",
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
                              left: screenSize.screenHeight * 5,
                              right: screenSize.screenHeight * 5,
                              top: screenSize.screenHeight * 2),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  validator: (val) => val.length < 6
                                      ? 'Enter a 6+ character long password'
                                      : null,
                                  obscureText: true,
                                  controller: passwordcontroller,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.start,
                                  onChanged: (pass) {
                                    this.password = pass;
                                    print(this.password);
                                  },
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: screenSize.screenHeight * 2),
                                  // focusNode: focusNode,
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
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenSize.screenHeight * 5,
                              right: screenSize.screenHeight * 5,
                              top: screenSize.screenHeight * 2),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val.length == 10)
                                      return null;
                                    else
                                      return "Please enter valid 10 digit phone number";
                                  },
                                  controller: phoneNocontroller,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.start,
                                  onChanged: (phone) {
                                    this.phoneNo = phone;
                                    print(this.phoneNo);
                                  },
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: screenSize.screenHeight * 2),
                                  // focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText: "Phone Number",
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
                              left: screenSize.screenHeight * 5,
                              right: screenSize.screenHeight * 5,
                              top: screenSize.screenHeight * 2),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  minLines: 3,
                                  maxLines: 5,
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an address' : null,
                                  controller: addresscontroller,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.start,
                                  onChanged: (address) {
                                    this.address = address;
                                    print(this.address);
                                  },
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: screenSize.screenHeight * 2),
                                  // focusNode: focusNode,
                                  decoration: InputDecoration(
                                    hintText: "Address",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenSize.screenHeight * 2)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenWidth * 6,
                  ),
                  Center(
                    child: Container(
                      height: screenSize.screenHeight * 10,
                      width: screenSize.screenWidth * 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: screenSize.screenWidth * 2,
                          ),
                          Center(
                              child: Text(
                            "Age",
                            style: TextStyle(
                                fontSize: screenSize.screenHeight * 2),
                          )),
                          SizedBox(
                            height: screenSize.screenHeight * 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: Row(
                                  children: <Widget>[
                                    age1,
                                    SizedBox(
                                      width: screenSize.screenWidth * 2,
                                    ),
                                    Text(
                                      "less than 18",
                                      style: TextStyle(
                                          fontSize:
                                              screenSize.screenHeight * 2),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    age1selected = true;
                                    age2selected = false;
                                    age3selected = false;
                                    this.age = "a";
                                  });
                                },
                              ),
                              SizedBox(
                                width: screenSize.screenWidth * 2,
                              ),
                              GestureDetector(
                                child: Row(
                                  children: <Widget>[
                                    age2,
                                    SizedBox(
                                      width: screenSize.screenWidth * 2,
                                    ),
                                    Text(
                                      "18-40",
                                      style: TextStyle(
                                          fontSize:
                                              screenSize.screenHeight * 2),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    age1selected = false;
                                    age2selected = true;
                                    age3selected = false;
                                    this.age = "b";
                                  });
                                },
                              ),
                              SizedBox(
                                width: screenSize.screenWidth * 2,
                              ),
                              GestureDetector(
                                child: Row(
                                  children: <Widget>[
                                    age3,
                                    SizedBox(
                                      width: screenSize.screenWidth * 2,
                                    ),
                                    Text(
                                      "above 40",
                                      style: TextStyle(
                                          fontSize:
                                              screenSize.screenHeight * 2),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    age1selected = false;
                                    age2selected = false;
                                    age3selected = true;
                                    this.age = "c";
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
//
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 6,
                  ),
                  Center(
                    child: ReusableButton(
                        height: screenSize.screenHeight * 8,
                        width: screenSize.screenWidth * 50,
                        content: "Register",
                        onPress: () async {
                          if (_formKey.currentState.validate()) {
                            FirebaseUser FireAccessUser =
                                await registerUserFirebase(email, password);
                            var a = await FireAccessUser.getIdToken();
                            String FireAccessToken = a.token;

                            String UId = FireAccessUser.uid;
                            if (FireAccessToken == error ||
                                FireAccessToken == null) {
                              Fluttertoast.showToast(msg: error);
                            } else {
                              print('fireAccess: ' + FireAccessToken);
                              print('going to phone check');
                              phoneCheck(
                                  phoneNo, context, FireAccessToken, UId);
                            }
                          } else {
                            print("Wrong data");
                          }
                        }),
                  ),
                  SizedBox(
                    height: screenSize.screenWidth * 5,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return Login(true);
                        }));
                      },
                      child: Text("Already a user? Sign In.",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenWidth * 5,
                  ),
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }

  void phoneCheck(String phone, BuildContext context, String fireAccessToken,
      String Uid) async {
    showAlertDialog(context);
    print('reached');
    PhoneCheck phoneCheck = PhoneCheck(phone);
    bool isPhoneVerified = await phoneCheck.check();
    print(isPhoneVerified.toString() + " phone verified");
    if (isPhoneVerified) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Phone Number already used");
    } else {
      Navigator.pop(context);
      print("sending OTP");

      await verifyPhone('+91' + phone, fireAccessToken, Uid);
    }
  }

  Future<void> verifyPhone(
      String phoneNo, String FireAccessToken, String UId) async {
//    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
//      this.verificationId = verId;
//    };
    print("UID: " + UId);
    print("FireAccessTOken: " + FireAccessToken);
    auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNo, // PHONE NUMBER TO SEND OTP

          codeSent: (String verificationId, [int forceResendingToken]) async {
            // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
            print("opening OTP Screen");
            String code;

            await smsOTPDialog(context).then((value) {
              print('sign in');
              code = value;
            });

            if (code != null) {
              showAlertDialog(context);
              print(code);
              print('process flow');
              try {
                AuthCredential credential = PhoneAuthProvider.getCredential(
                    verificationId: verificationId, smsCode: code);

                this.result.user.linkWithCredential(credential);
                print('process flow');
                //AuthResult result = await auth.signInWithCredential(credential);

                print('process flow');
                FirebaseUser user = result.user;
                if (user != null) {
//                  print('signed in with: ' +
//                      result.user.phoneNumber +
//                      " and " +
//                      result.user.email);

                  registerUserNetworking = RegisterUserNetworking(
                      name, email, password, this.phoneNo, address, age, UId);

                  int aT = await registerUserNetworking.postData();
                  if (aT == 200) {
                    Fluttertoast.showToast(msg: "Registered Successfully");
                    LoginPhoneNetworking loginPhoneNetworking =
                        LoginPhoneNetworking(
                            phone: this.phoneNo, accessToken: FireAccessToken);
                    print('sending data');
                    int status = await loginPhoneNetworking.postData();
                    if (status == 200) {
                      Fluttertoast.showToast(msg: "Login Successfully");
                      //FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                      signedIn = true;
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/homeScreen');
                    } else {
                      setState(() {
                        //clearTextInput();
                        Fluttertoast.showToast(
                            msg: "Please Check Internet Connection!");
                        print('LoginFailed');
                        setState(() {});
                      });
                    }
//                    auth.signOut();
//                    _auth.signOut();
                    signedIn = true;
                  } else {
                    setState(() {
                      clearTextInput();
                      age1selected = false;
                      age2selected = false;
                      age3selected = false;
                      Fluttertoast.showToast(msg: "Error!");
                    });
                  }
                } else {
                  print('ERROR');
                }
              } catch (e) {
                print(e);
              }
            } else {
              Fluttertoast.showToast(msg: "Please Enter OTP");
              print("code=null");
            }
          },
          timeout: const Duration(seconds: 60),
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
//            Navigator.pop(context);
//            this.verificationId = verId;
          },
          verificationCompleted: (AuthCredential phoneAuthCredential) {},
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<String> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    onChanged: (value) {
                      this.smsOTP = value;
                    },
                  ),
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                  child: Text('Done'),
                  onPressed: () {
                    Navigator.of(context).pop(smsOTP);
                  }),
            ],
          );
        });
  }

//  signIn() async {
//    try {
//      final AuthCredential credential = PhoneAuthProvider.getCredential(
//        verificationId: verificationId,
//        smsCode: smsOTP,
//      );
//      result.user.linkWithCredential(credential);
//      final FirebaseUser currentUser = await _auth.currentUser();
//      assert(result.user.uid == currentUser.uid);
//      Navigator.of(context).pop();
//
//      //Navigator.of(context).pushReplacementNamed('/homepage');
//    } catch (e) {
//      handleError(e);
//    }
//  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

//  Future<bool> loginUser(String phone, BuildContext context) {
//    Future<bool> verified;
//    _auth = FirebaseAuth.instance;
//    _auth.verifyPhoneNumber(
//        phoneNumber: phone,
//        timeout: Duration(seconds: 60),
//        verificationCompleted: (AuthCredential credential) async {
////          AuthResult authResult = await _auth.signInWithCredential(credential);
////          FirebaseUser user = authResult.user;
////          if (user != null) {
////            setState(() {
////              button = 'Send OTP';
////            });
////            var u = await user.getIdToken();
////
////            LoginPhoneNetworking loginPhoneNetworking =
////                LoginPhoneNetworking(phone: mobileNo, accessToken: u.token);
////            print('sending data');
////            int status = await loginPhoneNetworking.postData();
////            if (status == 200) {
////              Fluttertoast.showToast(msg: "Login Successfully");
////              print('fromAllCourse ' + widget.fromAllCourses.toString());
////              if (widget.fromAllCourses) {
////                print('going to Loading screen');
////                Navigator.pushReplacement(context,
////                    MaterialPageRoute(builder: (context) {
////                  return ListLoadingScreen();
////                }));
////              } else {
////                Navigator.pushReplacement(context,
////                    MaterialPageRoute(builder: (context) {
////                  //Here DecodedData is a locally savedvariable containing selected course data
////                  return CourseRegistrationLoadingScreen(DecodedData, false);
////                }));
////              }
////            } else {
////              setState(() {
////                //clearTextInput();
////                Fluttertoast.showToast(
////                    msg: "Please Check Internet Connection!");
////                setState(() {
////                  button = 'Send OTP';
////                });
////              });
////            }
////          } else {
////            print('ERROR');
////          }
////
////          Navigator.pop(context);
//        },
//        verificationFailed: (AuthException exception) {
//          print(exception.message);
//        },
//        codeSent: (String verificationId, [int forceResendingToken]) async {
//          print("opening OTP Screen");
//          String code;
//          print(widget.fromAllCourses);
//          await Navigator.push(context, MaterialPageRoute(builder: (context) {
//            //Here DecodedData is a locally saved variable containing selected course data
//            return EnterOtpScreen(widget.fromAllCourses);
//          })).then((value) {
//            code = value;
//          });
//
//          if (code != null) {
//            showAlertDialog(context);
//            print(code);
//            print('process flow');
//            try {
//              AuthCredential credential = PhoneAuthProvider.getCredential(
//                  verificationId: verificationId, smsCode: code);
//              print('process flow');
//              AuthResult result = await _auth.signInWithCredential(credential);
//              print('process flow');
//              FirebaseUser user = result.user;
//              if (user != null) {
//                print('signed in with: ' + result.user.phoneNumber);
//                var u = await user.getIdToken();
//                print(u.token);
//
//                LoginPhoneNetworking loginPhoneNetworking =
//                    LoginPhoneNetworking(phone: mobileNo, accessToken: u.token);
//                print('sending data');
//                int status = await loginPhoneNetworking.postData();
//                if (status == 200) {
//                  Fluttertoast.showToast(msg: "Login Successfully");
//                  FirebaseAuth.instance.signOut();
//                  Navigator.pop(context);
//                  signedIn = true;
//                  if (widget.fromAllCourses) {
//                    Navigator.pushReplacementNamed(context, '/homeScreen');
//                  } else {
//                    Navigator.pushReplacement(context,
//                        MaterialPageRoute(builder: (context) {
//                      //Here DecodedData is a locally saved variable containing selected course data
//                      return CourseRegistrationLoadingScreen(
//                          DecodedData, false);
//                    }));
//                  }
//                } else {
//                  setState(() {
//                    //clearTextInput();
//                    Fluttertoast.showToast(
//                        msg: "Please Check Internet Connection!");
//                    print('LoginFailed');
//                    setState(() {
//                      button = 'Send OTP';
//                    });
//                  });
//                }
//              } else {
//                print('ERROR');
//              }
//            } catch (e) {
//              print(e);
//            }
//          } else {
//            Fluttertoast.showToast(msg: "Please Enter OTP");
//            print("code=null");
//          }
//        },
//        codeAutoRetrievalTimeout: null);
//    return verified;
//  }

  Future<FirebaseUser> registerUserFirebase(String email, String pass) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (result == null) {
        setState(() {
          error = 'Please enter a valid email';
        });
      } else {
        FirebaseUser user = result.user;
        //var u = await user.getIdToken();

        return user;
      }
    } catch (e) {
      print(e.toString());
      error = "ERROR";
      return null;
    }
    return null;
  }
}
