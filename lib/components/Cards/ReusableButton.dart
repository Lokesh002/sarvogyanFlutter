import 'package:flutter/material.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class ReusableButton extends StatelessWidget {
  final Function onPress;
  final String content;
  final double height;
  final double width;
  double elev = 4.0;
  ReusableButton(
      {@required this.onPress,
      @required this.content,
      @required this.height,
      @required this.width});

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);

    return MaterialButton(
      onPressed: onPress,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(screenSize.screenHeight * 3),
        side: BorderSide(color: Theme.of(context).primaryColor),
      ),
      child: Text(
        content,
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: screenSize.screenHeight * 2,
            fontFamily: "Roboto"),
      ),
      elevation: elev,
      height: height,
      minWidth: width,
      color: Colors.white,
    );
  }
}
