import 'package:flutter/widgets.dart';

class SizeConfig {
  MediaQueryData _mediaQueryData;
  double screenWidth;
  double screenHeight;

  SizeConfig(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = (_mediaQueryData.size.width) / 100;
    screenHeight = (_mediaQueryData.size.height -
            _mediaQueryData.padding.top -
            _mediaQueryData.padding.bottom) /
        100;
  }
}
