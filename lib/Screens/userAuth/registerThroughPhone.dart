import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/userAuth/EnterBoardClassScreen.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/Screens/userAuth/registerUser.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/loginPhoneNetworking.dart';
import 'package:sarvogyan/components/phoneCheck.dart';
import 'package:sarvogyan/components/registerUserNetworking.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';

class RegisterThroughPhone extends StatefulWidget {
  @override
  _RegisterThroughPhoneState createState() => _RegisterThroughPhoneState();
}

class _RegisterThroughPhoneState extends State<RegisterThroughPhone> {
  SizeConfig screenSize;
  bool uploading = false;

  String smsOTP;
  String verificationId;
  String errorMessage = '';

  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential result;

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

  String tag;

  clearTextInput() {
    namecontroller.clear();
    emailcontroller.clear();
    passwordcontroller.clear();
    phoneNocontroller.clear();
    addresscontroller.clear();
  }

  List tags = ['School Student', 'College Student', 'Professional'];
  List<DropdownMenuItem> getDepartmentList() {
    List<DropdownMenuItem> departmentList = [];

    for (int i = 0; i < tags.length; i++) {
      var item = DropdownMenuItem(
        child: Text(tags[i]),
        value: tags[i],
      );
      departmentList.add(item);
    }

    return departmentList;
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

  Widget wait() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.orange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
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
      //resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          uploading
              ? wait()
              : ListView(
                  children: <Widget>[
                    Container(
                      child: Column(children: <Widget>[
                        Container(
                          width: screenSize.screenWidth * 100,
                          height: screenSize.screenHeight * 25,
                          child: Image.asset(
                            "images/logo.png",
                            fit: BoxFit.contain,
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
                              "Sign Up using Phone",
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
                                            validator: (val) => val.isEmpty
                                                ? 'Enter your name'
                                                : null,
                                            controller: namecontroller,
                                            keyboardType: TextInputType.text,
                                            textAlign: TextAlign.start,
                                            onChanged: (name) {
                                              this.name = name;
                                              print(this.name);
                                            },

                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize:
                                                    screenSize.screenHeight *
                                                        2),
                                            // focusNode: focusNode,
                                            decoration: InputDecoration(
                                              hintText: "Name",
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(screenSize
                                                              .screenHeight *
                                                          2)),
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
                                          padding:
                                              const EdgeInsets.only(top: 10),
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
                                                fontSize:
                                                    screenSize.screenHeight *
                                                        2),
                                            // focusNode: focusNode,
                                            decoration: InputDecoration(
                                              hintText: "Phone Number",
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(screenSize
                                                              .screenHeight *
                                                          2)),
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
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: TextFormField(
                                            minLines: 3,
                                            maxLines: 5,
                                            validator: (val) => val.isEmpty
                                                ? 'Enter an address'
                                                : null,
                                            controller: addresscontroller,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textAlign: TextAlign.start,
                                            onChanged: (address) {
                                              this.address = address;
                                              print(this.address);
                                            },
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize:
                                                    screenSize.screenHeight *
                                                        2),
                                            // focusNode: focusNode,
                                            decoration: InputDecoration(
                                              hintText: "Address",
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(screenSize
                                                              .screenHeight *
                                                          2)),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    SizedBox(
                                      height: screenSize.screenWidth * 2,
                                    ),
                                    Center(
                                        child: Text(
                                      "Age",
                                      style: TextStyle(
                                          fontSize:
                                              screenSize.screenHeight * 2),
                                    )),
                                    SizedBox(
                                      height: screenSize.screenHeight * 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Row(
                                            children: <Widget>[
                                              age1,
                                              SizedBox(
                                                width:
                                                    screenSize.screenWidth * 2,
                                              ),
                                              Text(
                                                "less than 18",
                                                style: TextStyle(
                                                    fontSize: screenSize
                                                            .screenHeight *
                                                        2),
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
                                                width:
                                                    screenSize.screenWidth * 2,
                                              ),
                                              Text(
                                                "18-40",
                                                style: TextStyle(
                                                    fontSize: screenSize
                                                            .screenHeight *
                                                        2),
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
                                                width:
                                                    screenSize.screenWidth * 2,
                                              ),
                                              Text(
                                                "above 40",
                                                style: TextStyle(
                                                    fontSize: screenSize
                                                            .screenHeight *
                                                        2),
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
                            Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black45),
                                  borderRadius: BorderRadius.circular(
                                      screenSize.screenHeight * 2),
                                ),
                                width: screenSize.screenWidth * 80,
                                height: screenSize.screenHeight * 11,
                                child: Center(
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              screenSize.screenWidth * 3),
                                      child: DropdownButtonFormField(
                                        disabledHint: Text("Choose category"),
                                        validator: (val) =>
                                            val == null ? 'Choose' : null,
                                        elevation: 7,
                                        isExpanded: false,
                                        hint: Text('Choose Category',
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontSize:
                                                    screenSize.screenHeight *
                                                        2)),
                                        value: tag,
                                        items: getDepartmentList(),
                                        onChanged: (value) {
                                          tag = value;
                                          print('selected: $tag');

                                          setState(() {});
                                        },
                                      )),
                                )),
                            SizedBox(
                              height: screenSize.screenHeight * 6,
                            ),
                            Center(
                              child: ReusableButton(
                                  height: screenSize.screenHeight * 8,
                                  width: screenSize.screenWidth * 50,
                                  content: "Register",
                                  onPress: () async {
                                    setState(() {
                                      uploading = true;
                                    });

                                    if (_formKey.currentState.validate()) {
                                      phoneCheck(phoneNo, context);
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
                                    return RegisterUser();
                                  }));
                                },
                                child: Text("Register using Email and Password",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat",
                                        fontStyle: FontStyle.normal,
                                        fontSize:
                                            screenSize.screenHeight * 1.7),
                                    textAlign: TextAlign.left),
                              ),
                            ),
                            SizedBox(
                              height: screenSize.screenWidth * 5,
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
                                            height:
                                                screenSize.screenHeight * 10,
                                          ),
                                          Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text("Already a User? ",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: screenSize
                                                                .screenHeight *
                                                            2),
                                                    textAlign: TextAlign.left),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return Login(true);
                                                    }));
                                                  },
                                                  child: Text("Sign In ",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: screenSize
                                                                  .screenHeight *
                                                              2),
                                                      textAlign:
                                                          TextAlign.left),
                                                ),
                                                Text("Now ! ",
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: screenSize
                                                                .screenHeight *
                                                            2),
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
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ]),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  void phoneCheck(String phone, BuildContext context) async {
    //showAlertDialog(context);
    print('reached');
    PhoneCheck phoneCheck = PhoneCheck(phone);
    bool isPhoneVerified = await phoneCheck.check();
    print(isPhoneVerified.toString() + " phone verified");
    if (isPhoneVerified) {
      //Navigator.pop(context);
      Fluttertoast.showToast(msg: "Phone Number already used");
    } else {
      //Navigator.pop(context);
      print("sending OTP");

      await verifyPhone('+91' + phone);
    }
  }

  Future<void> verifyPhone(String phoneNo) async {
    auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNo, // PHONE NUMBER TO SEND OTP

          codeSent: (String verificationId, [int forceResendingToken]) async {
            // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
            String code;

            await smsOTPDialog(context).then((value) {
              print('sign in');
              code = value;
            });

            if (code != null) {
              print(code);
              print('process flow');
              try {
                AuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: code);

                print('process flow');
                UserCredential result =
                    await auth.signInWithCredential(credential);

                print('process flow');
                User user = result.user;
                String UId = user.uid;
                String FireAccessToken;
                var z = await user.getIdTokenResult();
                FireAccessToken = z.token;
                if (user != null) {
                  registerUserNetworking = RegisterUserNetworking(
                      name,
                      email,
                      password,
                      this.phoneNo,
                      address,
                      age,
                      UId,
                      FireAccessToken,
                      tag,
                      (tag == 'Professional') ? 'no' : 'yes');

                  int aT = await registerUserNetworking.registerThroughPhone();
                  print("VALUE OF at : " + aT.toString());
                  if (aT == 200) {
                    Fluttertoast.showToast(msg: "Registered Successfully");
                  }
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
                    //Navigator.pop(context);
                    if (tag == "School Student") {
                      setState(() {
                        uploading = false;
                      });
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        //Here DecodedData is a locally saved variable containing selected course data
                        return EnterBoardClassScreen(
                            name: name, address: address, age: age);
                      }));

                      Navigator.pushReplacementNamed(context, '/homeScreen');
                    } else {
                      setState(() {
                        setState(() {
                          uploading = false;
                        });
                        //clearTextInput();
                        Fluttertoast.showToast(msg: "Error while Signing In!");
                        print('Login Failed');
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
                      Navigator.pop(context);
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
          verificationFailed: (FirebaseAuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<String> smsOTPDialog(BuildContext context) {
    setState(() {
      uploading = false;
    });
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
                    uploading = true;
                    Navigator.of(context).pop(smsOTP);
                  }),
            ],
          );
        });
  }

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
}
