import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sarvogyan/Screens/profile/addMoney/applyCouponCode.dart';
import 'package:sarvogyan/components/Cards/ReusableButton.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/components/updateBalance.dart';
import 'package:sarvogyan/utilities/userData.dart';

class MakePaymentScreen extends StatefulWidget {
  @override
  _MakePaymentScreenState createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  SizeConfig screenSize;
  int totalAmount = 0;
  Razorpay _razorpay;
  String OrderID;
  String receipt;
  String acsTkn;
  String button = 'Make Payment';
  SavedData savedData = SavedData();

  var _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void OpenCheckout() {
    var options = {
      'key': 'rzp_live_c6cRqluwJOv6by',
      'amount': totalAmount * 100,
      'name': 'Sarvogyan',
      'description': 'Test Payment',
      'prefill': {'contact': '', 'email': ''},
      'external': {'wallets': []},
      'order_id': OrderID,
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void getBalance(PaymentSuccessResponse response1) async {
    print(response1.signature);
    print(response1.paymentId);
    print(response1.orderId);
    http.Response response = await http.post(
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/payment/addBalance',
        headers: {"Content-Type": "application/json", "x-auth-token": acsTkn},
        body: convert.jsonEncode({
          'amount': totalAmount,
          'payment_id': response1.paymentId,
          'order_id': response1.orderId,
          'signature': response1.signature,
        }));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = convert.jsonDecode(data);
      OrderID = decodedData['id'];
      http.Response response2 = await http.get(
          'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user',
          headers: {
            "Content-Type": "application/json",
            "x-auth-token": acsTkn
          });
      if (response2.statusCode == 200) {
        userbalance = decodedData['balance'];
        savedData.setBalance(decodedData['balance']);
        print(decodedData['balance']);
        Navigator.pop(context, true);
      } else {
        print(response2.statusCode);
      }
    } else {
      print(response.statusCode);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Success :" + response.paymentId);
    getBalance(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Failure :" + response.code.toString() + ' - ' + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External Wallet :" + response.walletName);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    Navigator.pop(context, false);
    return true; // return true if the route to be popped
  }

//then pass the callback to WillPopScope

  UpdateBalance updateBalance = UpdateBalance();
  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Money to Wallet",
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: screenSize.screenHeight * 10,
                  ),
                  Container(
                    height: screenSize.screenHeight * 20,
                    child: SvgPicture.asset('svg/addMoneyToWallet.svg',
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Please enter the amount.",
                        ),
                        onChanged: (value) {
                          setState(() {
                            totalAmount = num.parse(value);
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 10,
                  ),
                  ReusableButton(
                    height: screenSize.screenHeight * 7,
                    width: screenSize.screenWidth * 50,
                    content: button,
                    onPress: () async {
                      this.setState(() {
                        button = 'Loading...';
                        _controller.clear();
                      });
                      acsTkn = await savedData.getAccessToken();
                      print("acsTKN: " + acsTkn);
                      http.Response response2 = await http.post(
                          'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/payment',
                          headers: {
                            "Content-Type": "application/json",
                            "x-auth-token": acsTkn
                          },
                          body: convert.jsonEncode({'amount': totalAmount}));
                      print('amount:' + totalAmount.toString());
                      if (response2.statusCode == 200) {
                        print(response2.statusCode);

                        String data = response2.body;
                        var decodedData = convert.jsonDecode(data);
                        OrderID = decodedData['id'];
                        print('api order: ' + OrderID);
                      } else {
                        print(response2.statusCode);
                      }

                      OpenCheckout();
                    },
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ApplyCouponCode();
                      }));
                    },
                    child: Text(
                      "Apply Coupon Code",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: screenSize.screenHeight * 2,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
//                                  SizedBox(
//                                    width: screenSize.screenWidth * 10,
//                                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
