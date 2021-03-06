import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/components/updateProfileSupport.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class EnterBoardClassScreen extends StatefulWidget {
  String name;
  String age;
  String address;
  EnterBoardClassScreen({this.name, this.address, this.age});
  @override
  _EnterBoardClassScreenState createState() => _EnterBoardClassScreenState();
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

class _EnterBoardClassScreenState extends State<EnterBoardClassScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  String name;
  String age;
  String address;
  String board;
  String studentClass;
  SizeConfig screenSize;

  bool isStudent;

  int _value = -1;
  SavedData savedData = SavedData();
  getData() async {
    name = widget.name;
    address = widget.address;
    age = widget.age;

    isStudent = await savedData.getIsStudent();

    setState(() {});
  }

  TextEditingController boardController = TextEditingController();
  TextEditingController classController = TextEditingController();

  void _handleRadioValueChanged(int value) {
    print(isStudent);
    _value = value;
    if (_value == 1) {
      print("clearing Data");
      classController.clear();
      boardController.clear();
      board = null;
      studentClass = null;
    }

    print("sdaj $_value");
    setState(() {});
  }

  @override
  void dispose() {
    boardController.dispose();
    classController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    Navigator.pop(context);

    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    List<String> choice = ["Yes", "No"];
    return MaterialApp(
      title: "Enter additional details",
      home: WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Additional Details"),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: screenSize.screenHeight * 3,
                  ),
                  Center(
                    child: Text(
                      "Are you a student?",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: screenSize.screenHeight * 3.5,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: screenSize.screenWidth * 30,
                        child: ListTile(
                            title: Text(
                              choice[0],
                            ),
                            leading: Radio<int>(
                                activeColor: Theme.of(context).primaryColor,
                                value: 0,
                                groupValue: _value,
                                onChanged: _handleRadioValueChanged)),
                      ),
                      Container(
                        width: screenSize.screenWidth * 30,
                        child: ListTile(
                            title: Text(
                              choice[1],
                            ),
                            leading: Radio<int>(
                              activeColor: Theme.of(context).primaryColor,
                              value: 1,
                              groupValue: _value,
                              onChanged: _handleRadioValueChanged,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 3,
                  ),
                  Text(
                    "Enter Board",
                    style: TextStyle(
                      color: _value == 0 ? Colors.black : Colors.grey,
                      fontSize: screenSize.screenHeight * 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(screenSize.screenHeight * 3),
                    child: TextFormField(
                      controller: boardController,
                      readOnly: _value != 0 ? true : false,
                      validator: (val) {
                        if (val.length == 10)
                          return null;
                        else
                          return "Please enter the Board";
                      },

                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        board = value;
                        print(board);
                      },
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: screenSize.screenHeight * 2),
                      // focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: "Board",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                screenSize.screenHeight * 2)),
                      ),
                    ),
                  ),
                  Text(
                    "Enter Class",
                    style: TextStyle(
                      color: _value == 0 ? Colors.black : Colors.grey,
                      fontSize: screenSize.screenHeight * 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(screenSize.screenHeight * 3),
                    child: TextFormField(
                      controller: classController,
                      readOnly: _value != 0 ? true : false,
                      validator: (val) {
                        if (val.length > 0)
                          return null;
                        else
                          return "Please enter the Class";
                      },

                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        studentClass = value;
                        print(studentClass);
                      },
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: screenSize.screenHeight * 2),
                      // focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: "Class",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                screenSize.screenHeight * 2)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 20,
                  ),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    height: screenSize.screenHeight * 7,
                    //width: screenSize.screenWidth * 50,
                    onPressed: () async {
                      isStudent =
                          _value == 0 ? true : (_value == 1 ? false : null);
                      if (isStudent != true) {
                        this.board = null;
                        this.studentClass = null;
                        print("problem found");
                        print(isStudent);
                        print("value" + this._value.toString());
                        print("address" + this.address.toString());
                        print("name" + this.name.toString());
                        print("board" + this.board.toString());
                        print("class" + this.studentClass.toString());
                        Navigator.pop(context);
                      } else {
                        print(isStudent);
                        print("value" + this._value.toString());
                        print("address" + this.address.toString());
                        print("name" + this.name.toString());
                        print("board" + this.board.toString());
                        print("class" + this.studentClass.toString());
                        UpdateProfileSave updateProfileSave = UpdateProfileSave(
                          address: this.address,
                          studentClass: studentClass,
                          name: name,
                          age: age,
                          board: board,
                          isStudent: isStudent,
                        );
                        showAlertDialog(this.context);
                        bool x = await updateProfileSave.updateProfile();
                        if (x == true) {
                          Navigator.pop(this.context);
                          Navigator.pop(this.context);
                        } else {
                          Navigator.pop(this.context);
                          Fluttertoast.showToast(
                              msg: "problem in saving updated profile data.");
                        }
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
