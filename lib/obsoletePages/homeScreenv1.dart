import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/course/ListloadingScreen.dart';
import 'package:sarvogyan/Screens/course/allCoursesScreen.dart';
import 'file:///D:/Projects/Flutter/sarvogyan/sarvogyan/lib/obsoletePages/seachScreen.dart';
import 'package:sarvogyan/Screens/course/search/searchCourse.dart';

import 'package:sarvogyan/Screens/docs/docsScreen.dart';
import 'package:sarvogyan/Screens/exams/examCategScreen.dart';
import 'package:sarvogyan/Screens/exams/examListLoadingScreen.dart';
import 'package:sarvogyan/Screens/course/myCourses/myCourses.dart';
import 'package:sarvogyan/Screens/NavDrawer.dart';
import 'package:sarvogyan/Screens/profile/SavedNotes.dart';
import 'package:sarvogyan/Screens/profile/certificate/certificateScreen.dart';
import 'package:sarvogyan/Screens/profile/myResultScreen.dart';
import 'package:sarvogyan/Screens/profile/subscription/buySubscription.dart';
import 'package:sarvogyan/Screens/profile/wishlist/wishlistScreen.dart';
import 'package:sarvogyan/Screens/userAuth/login.dart';
import 'package:sarvogyan/components/courseTree.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/lists/allCoursesList.dart';
import 'package:sarvogyan/utilities/sharedPref.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _widgets = <Widget>[];
  int _defaultIndex = 0;
  GetCourseClass getCourseClass = GetCourseClass();
  CourseTreeNode sarvogyan;
  int _selectedIndex;
  NavDrawer navDrawer = NavDrawer('homeScreen');
  void _onTapHandler(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  SavedData savedData = SavedData();

  getSignedInStatus() async {
    // print(signedIn);
    signedIn = await savedData.getLoggedIn();
    //  print(signedIn);
    if (signedIn == null) {
      signedIn = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sarvogyan = getCourseClass.process();
    _selectedIndex = _defaultIndex;
  }

  SizeConfig screenSize;
  @override
  Widget build(BuildContext context) {
    getSignedInStatus();
    screenSize = SizeConfig(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          drawer: navDrawer.getNavDrawer(context, sarvogyan),
          appBar: AppBar(
            actions: <Widget>[
              SizedBox(
                width: screenSize.screenWidth * 3,
              ),
              signedIn
                  ? PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: 'Profile',
                            child: Text('Profile'),
                          ),
                          PopupMenuItem(
                            value: 'Notes',
                            child: Text('My Notes'),
                          ),
                          PopupMenuItem(
                            value: 'Certificates',
                            child: Text('My Certificates'),
                          ),
                          PopupMenuItem(
                            value: 'Wishlist',
                            child: Text('My Wishlist'),
                          ),
                          PopupMenuItem(
                            value: 'Results',
                            child: Text('My Results'),
                          ),
                          PopupMenuItem(
                            value: 'Subscription',
                            child: Text('Subscription'),
                          )
                        ];
                      },
                      onSelected: (value) {
                        if (value == 'Profile') {
                          signedIn
                              ? Navigator.pushNamed(context, '/profile')
                              : Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return Login(true);
                                }));
                        }
                        if (value == 'Notes') {
                          signedIn
                              ? Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return SavedNotes();
                                }))
                              : Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return Login(true);
                                }));
                        }
                        if (value == 'Certificates') {
                          signedIn
                              ? Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return CertificateScreen();
                                }))
                              : Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return Login(true);
                                }));
                        }
                        if (value == 'Wishlist') {
                          signedIn
                              ? Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return WishlistScreen();
                                }))
                              : Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return Login(true);
                                }));
                        }
                        if (value == 'Results') {
                          signedIn
                              ? Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return MyResultScreen();
                                }))
                              : Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return Login(true);
                                }));
                        }
                        if (value == 'Subscription') {
                          signedIn
                              ? Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return BuySubscription();
                                }))
                              : Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                  return Login(true);
                                }));
                        }
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Login(true);
                        }));
                      },
                      child: Icon(
                        Icons.account_circle,
                        size: screenSize.screenHeight * 6,
                        color: Colors.white,
                      )),
              SizedBox(
                width: screenSize.screenWidth * 3,
              ),
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                      height: screenSize.screenHeight * 7,
                      child: Image.asset('images/media/logo.png')),
                ),
                Text("Sarvogyan",
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: screenSize.screenHeight * 3)),
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 5,
            bottom: TabBar(
              unselectedLabelColor: Theme.of(context).accentColor,
              indicator: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(screenSize.screenHeight * 5),
                color: Theme.of(context).accentColor,
              ),
              tabs: <Widget>[
                Tab(
                  child: Container(
                    child: CircleAvatar(
                      radius: screenSize.screenHeight * 2.5,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.search,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: CircleAvatar(
                      radius: screenSize.screenHeight * 2.5,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: CircleAvatar(
                      radius: screenSize.screenHeight * 2.5,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.library_books,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: CircleAvatar(
                      radius: screenSize.screenHeight * 2.5,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.border_color,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    child: CircleAvatar(
                      radius: screenSize.screenHeight * 2.5,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.description,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
              onTap: _onTapHandler,
            ),
          ),
          backgroundColor: Theme.of(context).accentColor,
          body: TabBarView(children: [
            SearchCourse(),
            MyCourses(),
            AllCoursesScreen(sarvogyan, sarvogyan.children[0], 'images/media'),
            ExamCategScreen(
                sarvogyan, "", sarvogyan.children[1], 'images/media'),
            DocsScreen('/documents'),
          ]),
        ),
      ),
    );
  }

  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to exit!");
      return Future.value(false);
    }
    return Future.value(true);
  }
}

class ActionInfo {
  final String id;
  final Icon icon;
  final String text;
  final Function func;

  const ActionInfo(
      {@required this.id,
      @required this.text,
      @required this.icon,
      @required this.func});
}