import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class AskDoubts extends StatefulWidget {
  var decData;
  AskDoubts(this.decData);
  @override
  _AskDoubtsState createState() => _AskDoubtsState();
}

class _AskDoubtsState extends State<AskDoubts> {
  List<Item> _doubts;
  SizeConfig screenSize;
  final doubtController = TextEditingController();

  String doubt;
  String noteTitle;
  final _formKey = GlobalKey<FormState>();
  String Uid;
  String accessToken;
  SavedData savedData = SavedData();
  String userName;
  List questions;
  bool isReady = false;
  getData() async {
    print(DateTime.now().toString());
    Uid = await savedData.getUserId();
    accessToken = await savedData.getAccessToken();
    userName = await savedData.getName();
    Networking networking = Networking();
    var data = await networking
        .getData('/api/user/getQuestions/$Uid/${widget.decData['id']}');

    print(data);
    questions = data;
    _doubts = generateItems(
        questions.length == null ? 0 : questions.length, questions, context);
    setState(() {
      isReady = true;
    });
  }

  List<Item> generateItems(
      int numberOfItems, List doubts, BuildContext context) {
    return List.generate(numberOfItems, (int index) {
      return Item(
          headerValue: Container(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: screenSize.screenHeight * 2),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doubts[index]['question'],
                      maxLines: 10,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Text(
                          'Created on: ${DateTime.fromMillisecondsSinceEpoch(int.parse(doubts[index]['date'])).toUtc().day.toString()}/${DateTime.fromMillisecondsSinceEpoch(int.parse(doubts[index]['date'])).toUtc().month.toString()}/${DateTime.fromMillisecondsSinceEpoch(int.parse(doubts[index]['date'])).toUtc().year.toString()}',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          expandedValue: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: doubts[index]['answer'] == ''
                    ? Text('Pending')
                    : Text(
                        doubts[index]['answer'],
                        maxLines: 100,
                      ),
              ),
              GestureDetector(
                onTap: () async {
                  Networking networking = Networking();
                  SavedData savedData = SavedData();
                  String acstkn = await savedData.getAccessToken();
                  var data = await networking.postDataByUser(
                      '/api/user/deleteQuestion',
                      {'id': doubts[index]['id']},
                      acstkn);
                  setState(() {
                    isReady = false;
                  });

                  getData();
                },
                child: Container(
                  color: Colors.red,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    doubtController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    if (!isReady)
      return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: SpinKitWanderingCubes(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          size: 100.0,
        ),
      );
    else
      return Scaffold(
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize.screenWidth * 5,
                  vertical: screenSize.screenHeight * 2),
              height: screenSize.screenHeight * 60,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenSize.screenHeight * 2,
                    ),
                    TextFormField(
                      minLines: 15,
                      maxLines: 15,
                      validator: (val) =>
                          val.isEmpty ? 'enter a valid doubt' : null,
                      controller: doubtController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      onChanged: (problemDesc) {
                        this.doubt = problemDesc;
                        print(this.doubt);
                      },
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: screenSize.screenHeight * 2),
                      // focusNode: focusNode,

                      decoration: InputDecoration(
                        hintText: "Ask a doubt",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                screenSize.screenHeight * 2)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.screenWidth * 5,
                          vertical: screenSize.screenHeight * 1),
                      child: ReusableButton(
                        width: screenSize.screenWidth * 20,
                        height: screenSize.screenHeight * 5,
                        onPress: () async {
                          if (_formKey.currentState.validate()) {
                            Networking networking = Networking();
                            print(widget.decData);
                            var data = await networking.postDataByUser(
                                'api/user/askQuestion',
                                {
                                  'question': doubt,
                                  'answer': '',
                                  'courseName': widget.decData['name'],
                                  'userName': userName,
                                  'uid': Uid,
                                  'cid': widget.decData['id'],
                                  'date': DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString()
                                },
                                accessToken);
                            doubtController.clear();

                            print(data);
                            setState(() {
                              isReady = false;
                            });
                            getData();

                            Fluttertoast.showToast(msg: "Done!");
//                        {
//                          noteTitle,
//                        noteDesc,
//                        courseName,
//                        uid,
//                        date,
                          }
                        },
                        content: "Ask doubt",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // _buildPanel(),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenSize.screenHeight * 2,
                  horizontal: screenSize.screenWidth * 2),
              child: _buildPanel(),
            ),
          ],
        ),
      );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _doubts[index].isExpanded = !isExpanded;
        });
      },
      children: _doubts.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: item.headerValue,
            );
          },
          body: ListTile(
            title: item.expandedValue,
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  Widget expandedValue;
  Widget headerValue;
  bool isExpanded;
}
