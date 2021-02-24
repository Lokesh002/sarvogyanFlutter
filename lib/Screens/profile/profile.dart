import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sarvogyan/Screens/profile/SavedNotes.dart';

import 'package:sarvogyan/Screens/profile/addMoney/applyCouponCode.dart';
import 'package:sarvogyan/Screens/profile/certificate/certificateScreen.dart';
import 'package:sarvogyan/Screens/profile/subscription/buySubscription.dart';
import 'package:sarvogyan/Screens/profile/updateProfile/updateProfile.dart';
import 'package:sarvogyan/Screens/userAuth/EnterBoardClassScreen.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/Screens/profile/myResultScreen.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';

import 'package:sarvogyan/utilities/userData.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/Screens/profile/addMoney/MakePaymentScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
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

class _ProfileViewState extends State<ProfileView> {
  String name = '';
  String email = '';

  String phoneNo = '';
  String address = '';
  String board = "";
  String studentClass = "";
  String age = '';
  String photo = '';
  int balance;
  SavedData savedData = SavedData();
  String levelOfSubscription = '';
  File _image;

  String tag;

  String uId;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    hello();
    getData();
    getProfilePic();
    getLevelOfSubscriber();
  }

  getProfilePic() async {
    String photo = await savedData.getProfileImage();
    if (photo != null) {
      this.photo = photo;
    }
    setState(() {});
  }

//  Future<Widget> getImage() async {
//    photo = await savedData.getProfileImage();
//    if (photo == null)
//      return Image.asset('images/flogo.png');
//    else
//      return Image.network(photo);
//  }

  getLevelOfSubscriber() async {
    String lev = await savedData.getUserSubsLevel();
    if (lev == 'a') {
      levelOfSubscription = "Free Subscriber";
    } else if (lev == 'b') {
      levelOfSubscription = "Basic Subscriber";
    } else if (lev == 'c') {
      levelOfSubscription = "Premium Subscriber";
    } else {
      levelOfSubscription = "Unauthorized Subscriber";
    }
  }

  final ImagePicker _picker = ImagePicker();
  getImageFromGallery(BuildContext cntext) async {
    try {
      var image = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: screenSize.screenHeight * 50,
        maxWidth: screenSize.screenWidth * 100,
      );
      setState(() {
        _image = File(image.path);
        print("image path: $image");
      });
    } catch (e) {}
    if (_image != null) {
      final response = await uploadImage(_image, cntext);
      print('asa' + response.toString());
      // Check if any error occured
      if (response == null) {
        //pr.hide();

        print('User details not updated');
      } else {
        setState(() {
          photo = response;
        });
        print(response);
      }
    } else {
      print('Please Select a profile photo');
    }
  }

  Future<String> uploadImage(File file, BuildContext context) async {
    showAlertDialog(context);
    String acstkn = await savedData.getAccessToken();
    Dio dio = Dio();
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    dio.options.headers["x-auth-token"] = acstkn;
    Response response = await dio.post(
      'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user/picture',
      data: formData,
    );
    print(response.data);
    photo = response.data;
    savedData.setProfileImage(photo);
    Navigator.pop(context);
    return (response.data);
  }

  Widget getDetail(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: screenSize.screenWidth * 4,
            ),
            Text(
              "$name: ",
              style: TextStyle(
                color: Colors.black,
                fontSize: screenSize.screenHeight * 1.7,
                fontFamily: "Roboto",
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: screenSize.screenWidth * 50,
              height: screenSize.screenHeight * 2.5,
              child: ListView(
                reverse: true,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Text(
                    value.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenSize.screenHeight * 1.7,
                      fontFamily: "Roboto",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: screenSize.screenWidth * 3,
            ),
          ],
        ),
      ],
    );
  }

  SizeConfig screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: screenSize.screenHeight * 45,
                    width: screenSize.screenWidth * 100,
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: screenSize.screenHeight * 10,
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: screenSize.screenHeight * 10,
                              child: ClipOval(
                                child: SizedBox(
                                  width: screenSize.screenWidth * 35,
                                  height: screenSize.screenWidth * 35,
                                  child: (photo == null || photo == '')
                                      ? Image.asset('images/flogo.png')
                                      : FadeInImage.assetNetwork(
                                          placeholder: 'images/flogo.png',
                                          image: photo),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                getImageFromGallery(context);
                              },
                              child: Icon(
                                Icons.add_circle,
                                color: Theme.of(context).accentColor,
                                size: screenSize.screenHeight * 5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 2,
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.screenHeight * 3.5,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                        Text(
                          levelOfSubscription,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.screenHeight * 2.5,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      width: screenSize.screenWidth * 80,
                      height: screenSize.screenHeight * 100,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: screenSize.screenHeight * 41,
                          ),
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.all(
                              Radius.circular(screenSize.screenHeight * 2),
                            ),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: screenSize.screenHeight * 5,
                                ),
                                getDetail('Phone', '+91-$phoneNo'),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                getDetail('Email', email),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                getDetail('Address', address),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                getDetail('Board', board),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                getDetail('Class', studentClass),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                getDetail('Balance', balance.toString()),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                getDetail('Tag', tag),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                getDetail('Account ID', uId),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    ReusableButton(
                                        onPress: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return UpdateProfile();
                                          })).then((v) {
                                            getData();
                                            setState(() {});
                                          });
                                        },
                                        content: "Update Profile",
                                        height: screenSize.screenHeight * 5,
                                        width: screenSize.screenWidth * 30),
                                    ReusableButton(
                                        onPress: () {
                                          userbalance = balance;
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return MakePaymentScreen();
                                          })).then((value) async {
                                            balance =
                                                await savedData.getBalance();
                                            setState(() {});
                                          });
                                        },
                                        content: "Add Money",
                                        height: screenSize.screenHeight * 5,
                                        width: screenSize.screenWidth * 30),
                                  ],
                                ),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                Center(
                                  child: ReusableButton(
                                      onPress: () {
                                        savedData.setLoggedIn(false);
                                        savedData.setAccessToken(null);
                                        savedData.setUserName(null);
                                        savedData.setAddress(null);
                                        savedData.setAge(null);
                                        savedData.setPhone(null);
                                        savedData.setEmail(null);
                                        savedData.setProfileImage(null);
                                        savedData.setCourse(null);
                                        savedData.setBalance(null);
                                        savedData.setUserSubsLevel(null);
                                        savedData.setTag(null);
                                        savedData.setUserId(null);
                                        savedData.setClass(null);
                                        savedData.setBoard(null);
                                        savedData.setIsStudent(null);
                                        FirebaseAuth.instance.signOut();
                                        signedIn = false;
                                        setState(() {});
                                        print(signedIn);
                                        print('$username logged out');

                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Login(true);
                                        }));
                                      },
                                      content: "Log Out",
                                      height: screenSize.screenHeight * 5,
                                      width: screenSize.screenWidth * 30),
                                ),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void getData() async {
    name = await savedData.getName();
    email = await savedData.getEmail();
    phoneNo = await savedData.getPhone();
    address = await savedData.getAddress();
    age = await savedData.getAge();
    balance = await savedData.getBalance();
    photo = await savedData.getProfileImage();
    board = await savedData.getBoard();
    studentClass = await savedData.getClass();
    tag = await savedData.getTag();
    uId = await savedData.getUserId();

    setState(() {});
  }
}

void hello() async {
  SavedData savedData = SavedData();
  print(
      '${await savedData.getName()} is logged in with ${await savedData.getAccessToken()}');
}
