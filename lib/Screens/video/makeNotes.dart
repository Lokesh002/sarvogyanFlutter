import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/Networking/networking.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class MakeNotes extends StatefulWidget {
  var decData;
  MakeNotes(this.decData);
  @override
  _MakeNotesState createState() => _MakeNotesState();
}

class _MakeNotesState extends State<MakeNotes> {
  List<Item> _books = generateItems(8);
  SizeConfig screenSize;
  final notesController = TextEditingController();
  final noteTitleController = TextEditingController();
  String note;
  String noteTitle;
  final _formKey = GlobalKey<FormState>();
  String Uid;
  SavedData savedData = SavedData();
  getData() async {
    Uid = await savedData.getUserId();
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
    noteTitleController.dispose();
    notesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenSize.screenWidth * 5,
                vertical: screenSize.screenHeight * 2),
            height: screenSize.screenHeight * 80,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    minLines: 1,
                    maxLines: 1,
                    validator: (val) => val.isEmpty ? 'Add Note title' : null,
                    controller: noteTitleController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    onChanged: (problemDesc) {
                      this.noteTitle = problemDesc;
                      print(this.noteTitle);
                    },
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: screenSize.screenHeight * 2),
                    // focusNode: focusNode,

                    decoration: InputDecoration(
                      hintText: "Note Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              screenSize.screenHeight * 2)),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 2,
                  ),
                  TextFormField(
                    minLines: 15,
                    maxLines: 15,
                    validator: (val) => val.isEmpty ? 'Add Note' : null,
                    controller: notesController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    onChanged: (problemDesc) {
                      this.note = problemDesc;
                      print(this.note);
                    },
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: screenSize.screenHeight * 2),
                    // focusNode: focusNode,

                    decoration: InputDecoration(
                      hintText: "Make a note",
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
                          var data = await networking
                              .postData('api/course/createNote', {
                            'noteTitle': noteTitle,
                            'noteDesc': note,
                            'courseName': widget.decData['name'],
                            'uid': Uid,
                            'date': DateTime.now().toString(),
                          });
                          notesController.clear();
                          noteTitleController.clear();
                          print(data);
                          Fluttertoast.showToast(msg: "Done!");
//                        {
//                          noteTitle,
//                        noteDesc,
//                        courseName,
//                        uid,
//                        date,
                        }
                      },
                      content: "+ Add Note",
                    ),
                  )
                ],
              ),
            ),
          ),
          // _buildPanel(),
        ],
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _books[index].isExpanded = !isExpanded;
        });
      },
      children: _books.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
            title: Text(item.expandedValue),
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

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Book $index',
      expandedValue: 'Details for Book $index goes here',
    );
  });
}
