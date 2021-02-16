import 'package:flutter/material.dart';
import 'package:sarvogyan/Screens/course/search/searchCourse.dart';
import 'package:sarvogyan/Screens/course/search/searchExam.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int currentIndex = 0;
  PageController pageController = new PageController();

  @override
  void dispose() {
    pageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          currentIndex = index;
          setState(() {});
        },
        controller: pageController,
        children: [
          SearchCourse(),
          SearchExams(),
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
        selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        unselectedIconTheme:
            IconThemeData(color: Theme.of(context).accentColor),
        unselectedLabelStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.grey.shade700,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: "Courses",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.border_color), label: "Exams"),
        ],
      ),
    );
  }
}
