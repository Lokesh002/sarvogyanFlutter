import 'package:flutter/material.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

Color primaryColor = Colors.blue;
Color accentColor = Colors.white;

class Themes {
  SavedData savedData = SavedData();

  int listColor = 0;
  List<Color> colorsList = [
    Colors.red[400],
    Colors.deepPurpleAccent,
    Colors.green,
    Colors.orange,
    Colors.pink[300],
    Colors.purpleAccent,
    Colors.lightBlueAccent,
    Colors.white70,
    Colors.white,
    Colors.yellow,
    Colors.orangeAccent,
    Colors.lightGreenAccent,
    Colors.black,
    Colors.red,
  ];
  List<int> colorIntList = [
    0xFFEF5350,
    0xFF651FFF,
    0xFF388E3C,
    0xFFEF6C00,
    0xFFF06292,
    0xFFEA80FC,
    0xFF80D8FF,
    0xB3FFFFFF,
    0xFFFFFFFF,
    0xFFFDD835,
    0xFFFF9100,
    0xFF76FF03,
    0xFF000000,
    0xFFE57373,
  ];
  Future<int> primary() async {
    int primary = await savedData.getPrimaryColor();
    if (primary == null) primary = 0xFFEF5350;
    return primary;
  }

  Future<int> accent() async {
    int accent = await savedData.getAccentColor();
    if (accent == null) accent = 0xFFFFFFFF;
    return accent;
  }

  Future getColor() async {
    int x = await primary();
    primaryColor = Color(x);

    int y = await accent();
    accentColor = Color(y);
  }
}
