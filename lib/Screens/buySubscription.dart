import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/components/ReusableButton.dart';
import 'package:sarvogyan/components/ReusableCard.dart';
import 'package:sarvogyan/components/reusableOptionCard.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:sarvogyan/components/ReusableButton.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

import 'package:sarvogyan/utilities/sharedPref.dart';
import 'package:sarvogyan/components/updateBalance.dart';
import 'package:sarvogyan/utilities/userData.dart';

import 'package:sarvogyan/utilities/sharedPref.dart';

class BuySubscription extends StatefulWidget {
  @override
  _BuySubscriptionState createState() => _BuySubscriptionState();
}

class _BuySubscriptionState extends State<BuySubscription> {
  SizeConfig screenSize;
  String time;
  int cost;
  String accessToken;
  SavedData savedData = SavedData();
  String subscription;
  Razorpay _razorpay;
  String acsTkn;
  String OrderID;
  int addAmount;
  Future getSubscription(PaymentSuccessResponse response) async {
    accessToken = await savedData.getAccessToken();

    http.Response response1 = await http.put(
        "http://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user/subscribe/" +
            subscription,
        headers: {
          "Content-Type": "application/json",
          "x-auth-token": accessToken
        },
        body: convert.jsonEncode({
          'time': time,
          'cost': cost,
        }));

    if (response1.statusCode == 200) {
      Fluttertoast.showToast(msg: "Bought Subscription");
      await savedData.setUserSubsLevel(subscription);
      print(await savedData.getUserSubsLevel());
      time = null;
      if (response != null) await getBalance(response);
    } else {
      time = null;
      Fluttertoast.showToast(msg: "Error.");
    }
  }

  Future openCheckout(int totalAmount) async {
    acsTkn = await savedData.getAccessToken();
    print("acsTKN: " + acsTkn);
    http.Response response2 = await http.post(
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/payment',
        headers: {"Content-Type": "application/json", "x-auth-token": acsTkn},
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

    var options = {
      'key': 'rzp_test_xasNNrw9VXtsnF',
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

  Future<String> timeDialog(BuildContext context) {
    String time;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter months of subscription'),
            content: Container(
              height: 85,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    onChanged: (value) {
                      time = value;
                    },
                  ),
                ),
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                  child: Text('Done'),
                  onPressed: () {
                    Navigator.pop(context, time);
                  }),
            ],
          );
        });
  }

  Future getBalance(PaymentSuccessResponse response1) async {
    print(response1.signature);
    print(response1.paymentId);
    print(response1.orderId);
    http.Response response = await http.post(
        'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/payment/addBalance',
        headers: {"Content-Type": "application/json", "x-auth-token": acsTkn},
        body: convert.jsonEncode({
          'amount': this.addAmount,
          'payment_id': response1.paymentId,
          'order_id': response1.orderId,
          'signature': response1.signature,
        }));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = convert.jsonDecode(data);
      print("adding amount: " + addAmount.toString() + " is successful");
      OrderID = decodedData['id'];
      http.Response response2 = await http.get(
          'https://us-central1-sarvogyan-course-platform.cloudfunctions.net/api/user',
          headers: {
            "Content-Type": "application/json",
            "x-auth-token": acsTkn
          });
      if (response2.statusCode == 200) {
        var decodedData = convert.jsonDecode(response2.body);
        userbalance = decodedData['balance'];
        savedData.setBalance(decodedData['balance']);
        print(decodedData['balance']);
      } else {
        print(response2.statusCode);
      }
    } else {
      print('ERROR adding amount!');
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Success :" + response.paymentId);
    getSubscription(response);
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

    super.dispose();
  }

  Future<bool> shouldSubscribe(String subscription) async {
    String subLevel = await savedData.getUserSubsLevel();
    print(subLevel);
    print(subscription);
    if (subLevel == subscription) {
      return false;
    } else {
      if (subLevel == 'b' && subscription == 'a') {
        return false;
      } else {
        if (subLevel == 'c' && (subscription == 'b' || subscription == 'a')) {
          return false;
        }
      }
    }

    return true;
  }

  Future<bool> sureDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Are you Sure?'),
            content: Container(
              height: screenSize.screenHeight * 5,
              width: screenSize.screenWidth * 60,
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                  color: Colors.green,
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  }),
              FlatButton(
                  color: Colors.red,
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  }),
            ],
          );
        });
  }

  onPressPremium(int time) async {
    subscription = 'c';
    bool sure;
    this.time = time.toString();
    bool x = await shouldSubscribe(subscription);
    print(x);
    if (x) {
      await sureDialog(context).then((value) {
        sure = value;
      });
      if (sure) {
        int balance = await savedData.getBalance();
        if (time == 3) {
          cost = 800;
        } else if (time == 6) {
          cost = 1200;
        } else if (time == 12) {
          cost = 2000;
        }
        print("cost $cost");
        if (balance < cost) {
          int remaining = cost - balance;
          addAmount = remaining;
          print("remaining $remaining");
          await openCheckout(remaining);
        } else {
          await getSubscription(null);
        }
      } else {
        Fluttertoast.showToast(msg: "You can subscribe any time you want.");
      }
    } else {
      String level = await savedData.getUserSubsLevel();
      String lev;
      if (level == 'a') {
        lev = "Free user";
      } else if (level == 'b') {
        lev = "Basic user";
      } else if (level == 'c') {
        lev = "Premium user";
      } else {
        lev = "Unauthorized";
      }
      Fluttertoast.showToast(msg: "Already a " + lev + " subscriber.");
    }
  }

  onPressBasic(int time) async {
    subscription = 'b';
    bool sure;
    this.time = time.toString();
    bool x = await shouldSubscribe(subscription);
    if (x) {
      await sureDialog(context).then((value) {
        sure = value;
      });
      if (sure) {
        int balance = await savedData.getBalance();
        if (time == 3) {
          cost = 400;
        } else if (time == 6) {
          cost = 800;
        } else if (time == 12) {
          cost = 1200;
        }
        print("cost $cost");
        if (balance < cost) {
          int remaining = cost - balance;
          addAmount = remaining;
          print("remaining $remaining");
          await openCheckout(remaining);
        } else {
          await getSubscription(null);
        }
      } else {
        Fluttertoast.showToast(msg: "You can subscribe any time you want.");
      }
    } else {
      String level = await savedData.getUserSubsLevel();
      String lev;
      if (level == 'a') {
        lev = "Free user";
      } else if (level == 'b') {
        lev = "Basic user";
      } else if (level == 'c') {
        lev = "Premium user";
      } else {
        lev = "Unauthorized";
      }
      Fluttertoast.showToast(msg: "Already a " + lev + " subscriber.");
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Buy Subscription"),
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: screenSize.screenHeight * 10,
                ),
                Container(
                  height: screenSize.screenHeight * 20,
                  child: SvgPicture.asset('svg/subscribe.svg',
                      semanticsLabel: 'A red up arrow'),
                ),
                SizedBox(
                  height: screenSize.screenHeight * 5,
                ),
                Container(
                  color: Theme.of(context).primaryColor,
                  width: screenSize.screenWidth * 100,
                  height: screenSize.screenHeight * 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableOptionCard(
                          width: screenSize.screenWidth * 40,
                          height: screenSize.screenHeight * 40,
                          elevation: 5,
                          color: Colors.white70,
                          cardChild: Column(
                            children: <Widget>[
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Image.asset(
                                'images/logo.png',
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Basic\nSubscription',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                '3 Months',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Rs. 400',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              ReusableButton(
                                height: screenSize.screenHeight * 7,
                                width: screenSize.screenWidth * 30,
                                content: "Buy",
                                onPress: () async {
                                  await onPressBasic(3);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableOptionCard(
                          width: screenSize.screenWidth * 40,
                          height: screenSize.screenHeight * 40,
                          elevation: 5,
                          color: Colors.white70,
                          cardChild: Column(
                            children: <Widget>[
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Image.asset(
                                'images/logo.png',
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Basic\nSubscription',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                '6 Months',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Rs. 800',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              ReusableButton(
                                height: screenSize.screenHeight * 7,
                                width: screenSize.screenWidth * 30,
                                content: "Buy",
                                onPress: () async {
                                  await onPressBasic(6);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableOptionCard(
                          width: screenSize.screenWidth * 40,
                          height: screenSize.screenHeight * 40,
                          elevation: 5,
                          color: Colors.white70,
                          cardChild: Column(
                            children: <Widget>[
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Image.asset(
                                'images/logo.png',
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Basic\nSubscription',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                '12 Months',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Rs. 1200',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              ReusableButton(
                                height: screenSize.screenHeight * 7,
                                width: screenSize.screenWidth * 30,
                                content: "Buy",
                                onPress: () async {
                                  await onPressBasic(12);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableOptionCard(
                          width: screenSize.screenWidth * 40,
                          height: screenSize.screenHeight * 40,
                          elevation: 5,
                          color: Colors.blueGrey,
                          cardChild: Column(
                            children: <Widget>[
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Image.asset(
                                'images/logo.png',
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Premium\nSubscription',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                '3 Months',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Rs. 800',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              ReusableButton(
                                height: screenSize.screenHeight * 7,
                                width: screenSize.screenWidth * 30,
                                content: "Buy",
                                onPress: () async {
                                  await onPressPremium(3);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableOptionCard(
                          width: screenSize.screenWidth * 40,
                          height: screenSize.screenHeight * 40,
                          elevation: 5,
                          color: Colors.blueGrey,
                          cardChild: Column(
                            children: <Widget>[
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Image.asset(
                                'images/logo.png',
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Premium\nSubscription',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                '6 Months',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Rs. 1200',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              ReusableButton(
                                height: screenSize.screenHeight * 7,
                                width: screenSize.screenWidth * 30,
                                content: "Buy",
                                onPress: () async {
                                  await onPressPremium(6);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReusableOptionCard(
                          width: screenSize.screenWidth * 40,
                          height: screenSize.screenHeight * 40,
                          elevation: 5,
                          color: Colors.blueGrey,
                          cardChild: Column(
                            children: <Widget>[
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Image.asset(
                                'images/logo.png',
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Premium\nSubscription',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                '12 Months',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              Text(
                                'Rs. 2000',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.screenHeight * 2,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: screenSize.screenHeight * 2,
                              ),
                              ReusableButton(
                                height: screenSize.screenHeight * 7,
                                width: screenSize.screenWidth * 30,
                                content: "Buy",
                                onPress: () async {
                                  await onPressPremium(12);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: false,
                  child: ReusableButton(
                    height: screenSize.screenHeight * 10,
                    width: screenSize.screenWidth * 60,
                    content: "Basic Subscription",
                    onPress: () async {
                      subscription = 'b';

                      bool x = await shouldSubscribe(subscription);
                      if (x) {
                        await timeDialog(context).then((value) {
                          time = value;
                        });
                        int balance = await savedData.getBalance();
                        if (balance < cost) {
                          int remaining = cost - balance;
                          addAmount = remaining;
                          await openCheckout(remaining);
                        } else {
                          await getSubscription(null);
                        }
                      } else {
                        String level = await savedData.getUserSubsLevel();
                        String lev;
                        if (level == 'a') {
                          lev = "Free user";
                        } else if (level == 'b') {
                          lev = "Basic user";
                        } else if (level == 'c') {
                          lev = "Premium user";
                        } else {
                          lev = "Unauthorized";
                        }
                        Fluttertoast.showToast(
                            msg: "Already a " + lev + " subscriber.");
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: false,
                  child: ReusableButton(
                    height: screenSize.screenHeight * 10,
                    width: screenSize.screenWidth * 60,
                    content: "Premium Subscription",
                    onPress: () async {
                      subscription = 'c';
                      bool x = await shouldSubscribe(subscription);
                      print(x);
                      if (x) {
                        await timeDialog(context).then((value) {
                          time = value;
                        });
                        int balance = await savedData.getBalance();

                        if (balance < cost) {
                          int remaining = cost - balance;
                          addAmount = remaining;
                          await openCheckout(remaining);
                        } else {
                          await getSubscription(null);
                        }
                      } else {
                        String level = await savedData.getUserSubsLevel();
                        String lev;
                        if (level == 'a') {
                          lev = "Free user";
                        } else if (level == 'b') {
                          lev = "Basic user";
                        } else if (level == 'c') {
                          lev = "Premium user";
                        } else {
                          lev = "Unauthorized";
                        }
                        Fluttertoast.showToast(
                            msg: "Already a " + lev + " subscriber.");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
