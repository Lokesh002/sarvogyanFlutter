import 'package:flutter/material.dart';
import 'package:sarvogyan/lists/theme.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class ChangeColour extends StatefulWidget {
  @override
  _ChangeColourState createState() => _ChangeColourState();
}

class _ChangeColourState extends State<ChangeColour> {
  int selectedColour;
  int selectedaccent;
  Color selectedlist;
  SavedData savedData = SavedData();
  Themes themes = Themes();
  List<DropdownMenuItem> getCategList() {
    List<DropdownMenuItem<int>> manufacturer_List = [];
    for (int i = 0; i < themes.colorIntList.length; i++) {
      var item = DropdownMenuItem(
        child: Container(
          color: Color(themes.colorIntList[i]),
          width: 20,
          height: 20,
        ),
        value: themes.colorIntList[i],
      );
      manufacturer_List.add(item);
    }

    return manufacturer_List;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Change Colour"),
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Primary Color: "),
                Container(
                    child: Material(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  child: Center(
                      child: DropdownButton(
                    elevation: 7,
                    isExpanded: false,
                    hint: Text('Choose'),
                    value: selectedColour,
                    items: getCategList(),
                    onChanged: (value) {
                      // await savedData.setPrimaryColor(selectedColour);
                      setState(() {
                        selectedColour = value;
                        primaryColor = Color(selectedColour);
                      });
                      setState(() {});
                    },
                  )),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Accent Color: "),
                Container(
                    child: Material(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  child: Center(
                      child: DropdownButton(
                    elevation: 7,
                    isExpanded: false,
                    hint: Text('Choose'),
                    value: selectedaccent,
                    items: getCategList(),
                    onChanged: (value) {
                      //await savedData.setAccentColor(selectedaccent);
                      setState(() {
                        selectedaccent = value;
                        accentColor = Color(selectedaccent);
                      });
                      setState(() {});
                    },
                  )),
                )),
              ],
            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Text("All course list Color: "),
//              ],
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Text("Exam List Color: "),
//              ],
//            )
          ],
        ),
      )),
    );
  }
}
