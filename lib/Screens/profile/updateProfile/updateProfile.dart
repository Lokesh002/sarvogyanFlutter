import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sarvogyan/Screens/profile/updateProfile/boardClassUpdate.dart';
import 'package:sarvogyan/Screens/userAuth/EnterBoardClassScreen.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/components/updateProfileSupport.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
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

class _UpdateProfileState extends State<UpdateProfile> {
  SizeConfig screenSize;
  String name = "";
  String board = "";
  String studentClass = "";
  bool isStudent;
  String address = "";
  String age = "";
  String tag;
  String newTag;
  SavedData savedData = SavedData();
  String profileImage;
  void getDetails() async {
    profileImage = await savedData.getProfileImage();
    tag = await savedData.getTag();
    name = await savedData.getName();
    address = await savedData.getAddress();
    age = await savedData.getAge();
    board = await savedData.getBoard();
    studentClass = await savedData.getClass();
    isStudent = await savedData.getIsStudent() == "yes" ? true : false;
    setState(() {});
  }

  Widget data(String title, String value, Function onPress) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenSize.screenHeight * 2,
                ),
              ),
              Container(
                width: screenSize.screenWidth * 55,
                child: Text(
                  value,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: screenSize.screenHeight * 1.7,
                      color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          ReusableButton(
              onPress: onPress,
              content: "EDIT",
              height: screenSize.screenHeight * 5,
              width: screenSize.screenWidth * 25)
//          MaterialButton(
//              onPressed: onPress,
//              child: Text("EDIT"),
//              color: Theme.of(context).primaryColor,
//              height: screenSize.screenHeight * 5,
//              minWidth: screenSize.screenWidth * 25)
        ],
      ),
    );
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

  @override
  void initState() {
    // TODO: implement initState
    getDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView(children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              Container(
                width: screenSize.screenWidth * 100,
                height: screenSize.screenHeight * 25,
                child: (profileImage == null)
                    ? Image.asset('images/media/logo.png')
                    : FadeInImage.assetNetwork(
                        placeholder: 'images/media/logo.png',
                        image: profileImage),
              ),
              SizedBox(
                height: screenSize.screenHeight * 2,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Update Profile",
                        style: TextStyle(
                          fontSize: screenSize.screenHeight * 3.5,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenSize.screenHeight * 2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: screenSize.screenHeight * 5,
                          right: screenSize.screenHeight * 5,
                          top: screenSize.screenHeight * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          data("Name", name, () {
                            setState(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return UpdateData(
                                  changeIn: "Name",
                                  ifAge: false,
                                );
                              })).then((value) {
                                setState(() {
                                  if (value != null) name = value;
                                });
                              });
                            });
                          }),
                          SizedBox(
                            height: screenSize.screenHeight * 2,
                          ),
                          data("Address", address, () {
                            setState(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return UpdateData(
                                  changeIn: "Address",
                                  ifAge: false,
                                );
                              })).then((value) {
                                setState(() {
                                  if (value != null) address = value;
                                });
                              });
                            });
                          }),
                          SizedBox(
                            height: screenSize.screenHeight * 2,
                          ),
                          data("Age", getAge(), () {
                            setState(() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return UpdateData(
                                  changeIn: "Age",
                                  ifAge: true,
                                );
                              })).then((value) {
                                setState(() {
                                  if (value != null) age = value;
                                });
                              });
                            });
                          }),
                          SizedBox(
                            height: screenSize.screenHeight * 2,
                          ),
                          data("Board & Class", board, () {
                            if (tag.contains('School')) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return BoardClassUpdate(
                                  board: board,
                                  isStudent: isStudent,
                                  sClass: studentClass,
                                );
                              })).then((value) {
                                print(value);
                                board = value == null
                                    ? "Not Selected"
                                    : value["board"];
                                studentClass = value == null
                                    ? "Not Selected"
                                    : value["class"];
                                isStudent = value == null
                                    ? isStudent
                                    : value["isStudent"];
                                setState(() {});
                              });
                            } else {
                              setState(() {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UpdateData(
                                    changeIn: "Board",
                                    ifAge: false,
                                  );
                                })).then((value) {
                                  setState(() {
                                    if (value != null) board = value;
                                  });
                                });
                              });
                            }
                          }),
                          SizedBox(
                            height: screenSize.screenHeight * 2,
                          ),
                          Text(
                            'Category:',
                            style: TextStyle(
                              fontSize: screenSize.screenHeight * 2,
                            ),
                          ),
                          SizedBox(
                            height: screenSize.screenHeight * 2,
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
                                        horizontal: screenSize.screenWidth * 3),
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
                                                  screenSize.screenHeight * 2)),
                                      value: newTag,
                                      items: getDepartmentList(),
                                      onChanged: (value) {
                                        newTag = value;
                                        print('selected: $newTag');

                                        setState(() {});
                                      },
                                    )),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenSize.screenWidth * 5,
                    ),
                  ]),
              ReusableButton(
                content: "Save",
                onPress: () async {
                  showAlertDialog(this.context);
                  UpdateProfileSave updateProfileSave = UpdateProfileSave(
                      address: address,
                      name: name,
                      studentClass: studentClass,
                      age: age,
                      tag: newTag == null ? tag : newTag,
                      board: board == "Not Selected" ? null : board,
                      isStudent: isStudent);
                  bool x = await updateProfileSave.updateProfile();
                  if (x) {
                    setState(() {});
                    Navigator.pop(this.context);
                    Fluttertoast.showToast(msg: "Profile Updated");
                    Navigator.pop(this.context, true);
                  } else {
                    Navigator.pop(this.context);
                    Fluttertoast.showToast(msg: "Profile Update Failed!");
                    Navigator.pop(this.context, true);
                  }
                },
                height: screenSize.screenHeight * 7,
                width: screenSize.screenWidth * 50,
              ),
              SizedBox(
                height: screenSize.screenHeight * 4,
              )
            ]),
          )
        ]),
      ),
    );
  }

  String getAge() {
    print('board:' + board);
    switch (age) {
      case "a":
        return "0 to 18";
      case "b":
        return "18 to 40";
      case "c":
        return "41 above";
      default:
        return "Null";
    }
  }
}

class UpdateData extends StatelessWidget {
  String changeIn;
  String changedData;
  bool ifAge = false;
  UpdateData({this.changeIn, this.ifAge});
  SizeConfig screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    if (ifAge) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 5,
          title: Text("Change $changeIn"),
        ),
        body: Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(screenSize.screenHeight * 2),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Change $changeIn"),
                  SizedBox(
                    height: screenSize.screenHeight * 3,
                  ),
                  Column(
                    children: <Widget>[
                      ReusableButton(
                          content: "0 to 17",
                          onPress: () {
                            Navigator.pop(context, "a");
                          },
                          height: screenSize.screenHeight * 7,
                          width: screenSize.screenWidth * 50),
                      SizedBox(
                        height: screenSize.screenHeight * 3,
                      ),
                      ReusableButton(
                          content: "18 to 40",
                          onPress: () {
                            Navigator.pop(context, "b");
                          },
                          height: screenSize.screenHeight * 7,
                          width: screenSize.screenWidth * 50),
                      SizedBox(
                        height: screenSize.screenHeight * 3,
                      ),
                      ReusableButton(
                          content: "41 and above",
                          onPress: () {
                            Navigator.pop(context, "c");
                          },
                          height: screenSize.screenHeight * 7,
                          width: screenSize.screenWidth * 50),
                      SizedBox(
                        height: screenSize.screenHeight * 3,
                      ),
                    ],
                  )
                ]),
          ),
        ),
      );
    } else
      return Scaffold(
        appBar: AppBar(
          elevation: 5,
          title: Text("Change $changeIn"),
        ),
        body: Container(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenSize.screenHeight * 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: screenSize.screenHeight * 25,
                    ),
                    Text("Change $changeIn"),
                    Container(
                      padding: EdgeInsets.all(screenSize.screenHeight * 3),
                      child: TextFormField(
                        validator: (val) {
                          if (val.length == 10)
                            return null;
                          else
                            return "Please enter the $changeIn";
                        },

                        keyboardType: changeIn == "Class"
                            ? TextInputType.number
                            : TextInputType.text,
                        textAlign: TextAlign.start,
                        onChanged: (value) {
                          this.changedData = value;
                          print(this.changedData);
                        },
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: screenSize.screenHeight * 2),
                        // focusNode: focusNode,
                        decoration: InputDecoration(
                          hintText: changeIn,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  screenSize.screenHeight * 2)),
                        ),
                      ),
                    ),
                  ],
                ),
                ReusableButton(
                    content: "Done",
                    onPress: () {
                      Navigator.pop(context, changedData);
                    },
                    height: screenSize.screenHeight * 7,
                    width: screenSize.screenWidth * 50),
                SizedBox(
                  height: screenSize.screenHeight * 3,
                ),
              ],
            ),
          ),
        )),
      );
  }
}
