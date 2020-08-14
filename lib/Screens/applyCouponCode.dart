import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sarvogyan/components/ReusableButton.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/components/updateBalance.dart';
import 'package:sarvogyan/utilities/userData.dart';

class ApplyCouponCode extends StatefulWidget {
  @override
  _ApplyCouponCodeState createState() => _ApplyCouponCodeState();
}

class _ApplyCouponCodeState extends State<ApplyCouponCode> {
  SizeConfig screenSize;
  String couponCode;

  String acsTkn;
  String button = 'Apply';
  SavedData savedData = SavedData();

  var _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void applyCoupon() async {
    acsTkn = await savedData.getAccessToken();
    http.Response response1 = await http.put(
      'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/coupon/redeem/' +
          couponCode,
      headers: {"Content-Type": "application/json", "x-auth-token": acsTkn},
    );
    if (response1.statusCode == 200) {
      String data = response1.body;
      var decodedData = convert.jsonDecode(data);
      await savedData.setBalance(decodedData['balance']);
      print(response1.statusCode);
      Fluttertoast.showToast(msg: "Code Successfully applied!");
      Navigator.pop(context, decodedData['balance']);
    } else {
      print(response1.statusCode);
      String data = response1.body;
      var decodedData = convert.jsonDecode(data);
      Fluttertoast.showToast(msg: decodedData['msg']);
      setState(() {
        button = 'Apply';
      });
    }
  }

//then pass the callback to WillPopScope

  UpdateBalance updateBalance = UpdateBalance();
  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Apply Coupon Code",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5,
      ),
      body: Center(
        child: Container(
          height: screenSize.screenHeight * 80,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: screenSize.screenHeight * 10,
                ),
                Container(
                  height: screenSize.screenHeight * 20,
                  child: SvgPicture.asset('svg/coupon.svg',
                      semanticsLabel: 'A red up arrow'),
                ),
                SizedBox(
                  height: screenSize.screenHeight * 10,
                ),
                Container(
                  width: screenSize.screenWidth * 80,
                  child: LimitedBox(
                    maxWidth: screenSize.screenWidth * 70,
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Please enter the Coupon Code",
                      ),
                      onChanged: (value) {
                        setState(() {
                          couponCode = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenSize.screenHeight * 10,
                ),
                ReusableButton(
                  height: screenSize.screenHeight * 10,
                  width: screenSize.screenWidth * 50,
                  content: button,
                  onPress: () async {
                    this.setState(() {
                      button = 'Loading...';
                      _controller.clear();
                    });
                    applyCoupon();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
