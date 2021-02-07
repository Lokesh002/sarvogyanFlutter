import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:sarvogyan/Screens/profile/addMoney/applyCouponCode.dart';
import 'package:sarvogyan/Screens/profile/subscription/buySubscription.dart';
import 'package:sarvogyan/Screens/profile/updateProfile/updateProfile.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/Screens/profile/myResultScreen.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';

import 'package:sarvogyan/utilities/userData.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/Screens/profile/addMoney/MakePaymentScreen.dart';
import 'package:image_picker/image_picker.dart';

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
  String password = '';
  String phoneNo = '';
  String address = '';
  String board = "";
  String studentClass = "";
  String age = '';
  String photo =
      'https://firebasestorage.googleapis.com/v0/b/sarvogyan-course-platform.appspot.com/o/sarvogyan-logo.jpg?alt=media&token=57068781-79f3-4f3c-b3e2-8be92c43e9a8';
  int balance;
  SavedData savedData = SavedData();
  String levelOfSubscription = '';
  File _image;
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
//      return Image.asset('images/logo.png');
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

  getImageFromGallery(BuildContext cntext) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print("image path: $image");
    });
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

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);

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
                                  child: (photo == null)
                                      ? Image.asset('images/logo.png')
                                      : FadeInImage.assetNetwork(
                                          placeholder: 'images/logo.png',
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: screenSize.screenWidth * 5,
                                        ),
                                        Text(
                                          "Phone: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          phoneNo,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenSize.screenWidth * 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: screenSize.screenWidth * 5,
                                        ),
                                        Text(
                                          "Email: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          email,
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenSize.screenWidth * 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: screenSize.screenWidth * 5,
                                        ),
                                        Text(
                                          "Address: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: screenSize.screenWidth * 50,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: screenSize.screenWidth * 45,
                                            height: screenSize.screenHeight * 3,
                                            child: ListView(
                                              reverse: true,
                                              scrollDirection: Axis.horizontal,
                                              children: <Widget>[
                                                Text(
                                                  address,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: screenSize
                                                            .screenHeight *
                                                        2,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenSize.screenWidth * 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: screenSize.screenWidth * 5,
                                        ),
                                        Text(
                                          "Board: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          board.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenSize.screenWidth * 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: screenSize.screenWidth * 5,
                                        ),
                                        Text(
                                          "Class: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          studentClass.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenSize.screenWidth * 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: screenSize.screenWidth * 5,
                                        ),
                                        Text(
                                          "Balance: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          balance.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                screenSize.screenHeight * 2,
                                            fontFamily: "Roboto",
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenSize.screenWidth * 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenSize.screenHeight * 1,
                                ),
                                ReusableButton(
                                    onPress: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return UpdateProfile();
                                      })).then((v) {
                                        getData();
                                        setState(() {});
                                      });
                                    },
                                    content: "Update Profile",
                                    height: screenSize.screenHeight * 5,
                                    width: screenSize.screenWidth * 30),
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
                                            return ApplyCouponCode();
                                          })).then((value) async {
                                            if (value != null) {
                                              balance = value;
                                            } else {
                                              balance =
                                                  await savedData.getBalance();
                                            }
                                            setState(() {});
                                          });
                                        },
                                        content: "Apply Coupon Code",
                                        height: screenSize.screenHeight * 5,
                                        width: screenSize.screenWidth * 30),
//                                  SizedBox(
//                                    width: screenSize.screenWidth * 10,
//                                  ),

                                    ReusableButton(
                                        onPress: () {
                                          userbalance = balance;
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return MakePaymentScreen();
                                          })).then((value) {
                                            setState(() {
                                              balance = userbalance;
                                            });
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    ReusableButton(
                                        onPress: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return BuySubscription();
                                          })).then((value) async {
                                            if (value != null) {
                                              balance = value;
                                            } else {
                                              balance =
                                                  await savedData.getBalance();
                                            }
                                            setState(() {});
                                          });
                                        },
                                        content: "Subscribe",
                                        height: screenSize.screenHeight * 5,
                                        width: screenSize.screenWidth * 30),
                                    ReusableButton(
                                        onPress: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return MyResultScreen();
                                          }));
                                        },
                                        content: "See Result",
                                        height: screenSize.screenHeight * 5,
                                        width: screenSize.screenWidth * 30),
                                  ],
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
                                  height: screenSize.screenHeight * 5,
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
    setState(() {});
  }
}

void hello() async {
  SavedData savedData = SavedData();
  print(
      '${await savedData.getName()} is logged in with ${await savedData.getAccessToken()}');
}
