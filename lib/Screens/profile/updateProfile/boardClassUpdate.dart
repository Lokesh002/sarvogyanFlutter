import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/components/Constants/constants.dart';
import 'package:sarvogyan/components/courseTree.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/components/updateProfileSupport.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class BoardClassUpdate extends StatefulWidget {
  final String board;
  final String sClass;
  final bool isStudent;
  BoardClassUpdate({this.board, this.isStudent, this.sClass});
  @override
  _BoardClassUpdateState createState() => _BoardClassUpdateState();
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

class _BoardClassUpdateState extends State<BoardClassUpdate> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    sarvogyan = getCourseClass.process();
  }

  GetCourseClass getCourseClass = GetCourseClass();

  String board;
  String studentClass;
  SizeConfig screenSize;

  bool isStudent;
  CourseTreeNode chosenBoard;
  int _value = -1;
  SavedData savedData = SavedData();
  getData() async {
    isStudent = await savedData.getIsStudent() == "yes" ? true : false;

    setState(() {});
  }

  TextEditingController boardController = TextEditingController();
  TextEditingController classController = TextEditingController();

  CourseTreeNode sarvogyan;
  List<DropdownMenuItem> getBoard() {
    List<DropdownMenuItem> boardList = [];

    for (int i = 0;
        i < sarvogyan.children[0].children[0].children.length;
        i++) {
      var item = DropdownMenuItem(
        child: Text(sarvogyan.children[0].children[0].children[i].value),
        value: sarvogyan.children[0].children[0].children[i],
      );
      boardList.add(item);
    }

    return boardList;
  }

  List<DropdownMenuItem> getClass(CourseTreeNode c) {
    List<DropdownMenuItem> classList = [];
    if (chosenBoard != null) {
      for (int i = 0; i < c.children.length; i++) {
        var item = DropdownMenuItem(
          child: Text(c.children[i].value),
          value: c.children[i].value,
        );
        classList.add(item);
      }

      return classList;
    } else
      return null;
  }

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

    print("$_value");
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
    print('heelo');
    // then
    Navigator.pop(context, {
      'board': widget.board,
      'class': widget.sClass,
      'isStudent': widget.isStudent
    });
    return true;
    // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    List<String> choice = ["Yes", "No"];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Additional Details"),
      ),
      body: WillPopScope(
        onWillPop: _willPopCallback,
        child: Container(
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
                SizedBox(
                  height: screenSize.screenHeight * 6,
                ),
                Container(
                    width: screenSize.screenWidth * 80,
                    height: screenSize.screenHeight * 11,
                    child: Material(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(screenSize.screenHeight * 1),
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.screenWidth * 3),
                            child: DropdownButtonFormField(
                              disabledHint: Text("Not a student"),
                              validator: (val) =>
                                  val == null ? 'Select Board' : null,
                              elevation: 7,
                              isExpanded: false,
                              hint: Text('Choose',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor)),
                              value: chosenBoard,
                              items: _value == 0 ? getBoard() : null,
                              onChanged: (value) {
                                chosenBoard = value;
                                board = chosenBoard.value;
                                print('selected1: $board');

                                setState(() {});
                              },
                            )),
                      ),
                    )),
                SizedBox(
                  height: screenSize.screenHeight * 3,
                ),
                Text(
                  "Enter Class",
                  style: TextStyle(
                    color: _value == 0 ? Colors.black : Colors.grey,
                    fontSize: screenSize.screenHeight * 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenSize.screenHeight * 6,
                ),
                Container(
                    width: screenSize.screenWidth * 80,
                    height: screenSize.screenHeight * 11,
                    child: Material(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(screenSize.screenHeight * 1),
                      ),
                      child: Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.screenWidth * 3),
                            child: DropdownButtonFormField(
                              disabledHint: Text("First choose board"),
                              validator: (val) =>
                                  val == null ? 'Select Class' : null,
                              elevation: 7,
                              isExpanded: false,
                              hint: Text('Choose',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor)),
                              value: studentClass,
                              items: getClass(chosenBoard),
                              onChanged: (value) {
                                studentClass = value;
                                print('selected1: $studentClass');

                                setState(() {});
                              },
                            )),
                      ),
                    )),
                SizedBox(
                  height: screenSize.screenHeight * 3,
                ),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  height: screenSize.screenHeight * 7,
                  //width: screenSize.screenWidth * 50,
                  onPressed: () async {
                    isStudent =
                        _value == 0 ? true : (_value == 1 ? false : false);
                    if (isStudent != true) {
                      this.board = null;
                      this.studentClass = null;

                      print(isStudent);

                      print("board" + this.board.toString());
                      print("class" + this.studentClass.toString());
                      Navigator.pop(context);
                    } else {
                      showAlertDialog(this.context);
                      print(isStudent);
                      print("value" + this._value.toString());

                      print("board" + this.board.toString());
                      print("class" + this.studentClass.toString());

                      Navigator.pop(this.context);
                      Navigator.pop(this.context, {
                        'board': this.board,
                        'class': this.studentClass,
                        'isStudent': this.isStudent
                      });
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
    );
  }
}
