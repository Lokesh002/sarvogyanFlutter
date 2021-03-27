import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarvogyan/components/Cards/ReusableCard.dart';
import 'package:sarvogyan/components/Cards/courseCard.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class ReusableCourseDialogCard extends StatelessWidget {
  final String courseName;
  final String subscription;
  final String teacher;
  final Function onTap;
  final Function onChangeTap;
  final Color color;
  final String image;
  final int lessons;
  ReusableCourseDialogCard(
      {this.courseName,
      this.subscription,
      this.teacher,
      this.onTap,
      this.onChangeTap,
      this.color,
      this.image,
      this.lessons});

  @override
  Widget build(BuildContext context) {
    SizeConfig screenSize = SizeConfig(context);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: screenSize.screenWidth * 0.5,
          ),
          Column(
            children: <Widget>[
              CourseCard(
                color: this.color,
                width: screenSize.screenWidth * 62,
                // height: screenSize.screenHeight * 10,
                cardChild: Row(
                  children: <Widget>[
                    SizedBox(
                      width: screenSize.screenWidth * 3,
                    ),
                    SizedBox(
                      width: screenSize.screenWidth * 10,
                      height: screenSize.screenWidth * 10,
                      child: (image != null)
                          ? FadeInImage.assetNetwork(
                              placeholder: 'images/media/logo.png',
                              image: this.image)
                          : Image.asset('images/media/logo.png'),
                    ),
                    SizedBox(
                      width: screenSize.screenWidth * 1,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: screenSize.screenHeight * 1.5,
                        ),
                        Container(
                          width: screenSize.screenWidth * 47,
                          child: Text(
                            '$courseName',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: screenSize.screenHeight * 1.8,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                        Text(
                          '$subscription',
                          style: TextStyle(
                            fontSize: screenSize.screenHeight * 1.5,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                        subscription != 'Free Course'
                            ? Text(
                                teacher != null ? 'Teacher: $teacher' : '',
                                style: TextStyle(
                                  fontSize: screenSize.screenHeight * 1.5,
                                  color: Colors.black26,
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: screenSize.screenHeight * 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.screenHeight * 1,
              )
            ],
          ),
          SizedBox(
            width: screenSize.screenWidth * 1,
          ),
        ],
      ),
    );
  }
}
