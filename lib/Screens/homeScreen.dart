import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sarvogyan/Screens/course/ListloadingScreen.dart';
import 'package:sarvogyan/Screens/course/allCoursesScreen.dart';
import 'package:sarvogyan/Screens/course/search/seachScreen.dart';
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
import 'package:sarvogyan/lists/allCategory_list.dart';
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

  int currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sarvogyan = getCourseClass.process();
    _selectedIndex = _defaultIndex;
  }

  PageController pageController = new PageController();

  @override
  void dispose() {
    pageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  SizeConfig screenSize;
  @override
  Widget build(BuildContext context) {
    getSignedInStatus();
    screenSize = SizeConfig(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        drawer: navDrawer.getNavDrawer(context, sarvogyan),
        appBar: AppBar(
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
          actions: [
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
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 5,
        ),
        body: PageView(
          onPageChanged: (index) {
            currentIndex = index;
            setState(() {});
          },
          controller: pageController,
          children: [
            SearchCourse(),
            MyCourses(),
            AllCoursesScreen(sarvogyan, sarvogyan.children[0], 'images/media'),
            ExamCategScreen(
                sarvogyan, "", sarvogyan.children[1], 'images/media'),
            DocsScreen('/documents')
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (page) {
            setState(() {
              currentIndex = page;
            });
            pageController.jumpToPage(page);
          },
          currentIndex: currentIndex,
          selectedIconTheme:
              IconThemeData(color: Theme.of(context).primaryColor),
          unselectedIconTheme:
              IconThemeData(color: Theme.of(context).accentColor),
          unselectedLabelStyle: TextStyle(color: Colors.white),
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                child: CircleAvatar(
                  radius: screenSize.screenHeight * 2.5,
                  backgroundColor: currentIndex == 0
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  child: Icon(
                    Icons.search,
                    color: currentIndex == 0 ? Colors.white : Colors.black,
                  ),
                ),
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
                icon: Container(
                  child: CircleAvatar(
                    radius: screenSize.screenHeight * 2.5,
                    backgroundColor: currentIndex == 1
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    child: Icon(
                      currentIndex == 1
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: currentIndex == 1 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                label: 'My Courses'),
            BottomNavigationBarItem(
                icon: Container(
                  child: CircleAvatar(
                    radius: screenSize.screenHeight * 2.5,
                    backgroundColor: currentIndex == 2
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    child: Icon(
                      currentIndex == 2
                          ? Icons.library_books
                          : Icons.library_books_outlined,
                      color: currentIndex == 2 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                label: 'All Courses'),
            BottomNavigationBarItem(
                icon: Container(
                  child: CircleAvatar(
                    radius: screenSize.screenHeight * 2.5,
                    backgroundColor: currentIndex == 3
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    child: Icon(
                      Icons.border_color,
                      size: screenSize.screenHeight * 3,
                      color: currentIndex == 3 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                label: 'Exams'),
            BottomNavigationBarItem(
                icon: Container(
                  child: CircleAvatar(
                    radius: screenSize.screenHeight * 2.5,
                    backgroundColor: currentIndex == 4
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    child: Icon(
                      currentIndex == 4
                          ? Icons.description
                          : Icons.description_outlined,
                      color: currentIndex == 4 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                label: 'E Books'),
          ],
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
