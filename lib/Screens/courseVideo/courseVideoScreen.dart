import 'package:flutter/material.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sarvogyan/components/sizeConfig.dart';
import 'package:sarvogyan/Screens/course/readCourseDocScreen.dart';
import 'package:sarvogyan/components/Constants/constants.dart';

class CourseVideoScreen extends StatefulWidget {
  final String id;
  final String name;
  final String desc;
  final previewData;
  CourseVideoScreen({this.id, this.name, this.desc, this.previewData});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CourseVideoScreen>
    implements YouTubePlayerListener {
  double _volume = 50;
  double _videoDuration = 0.0;
  double _currentVideoSecond = 0.0;
  String _playerState = "";
  FlutterYoutubeViewController _controller;
  YoutubeScaleMode _mode = YoutubeScaleMode.none;
  PlaybackRate _playbackRate = PlaybackRate.RATE_1;
  bool _isMuted = false;

  @override
  void onCurrentSecond(double second) {
    print("onCurrentSecond second = $second");
    _currentVideoSecond = second;
  }

  @override
  void onError(String error) {
    print("onError error = $error");
  }

  @override
  void onReady() {
    print("onReady");
  }

  @override
  void onStateChange(String state) {
    print("onStateChange state = $state");
    setState(() {
      _playerState = state;
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  void onVideoDuration(double duration) {
    print("onVideoDuration duration = $duration");
  }

  void _onYoutubeCreated(FlutterYoutubeViewController controller) {
    this._controller = controller;
  }

  void _loadOrCueVideo() {
    _controller.loadOrCueVideo(widget.id, _currentVideoSecond);
  }

  void _play() {
    _controller.play();
  }

  void _pause() {
    _controller.pause();
  }

  void _seekTo(double time) {
    _controller.seekTo(time);
  }

  void _setVolume(int volumePercent) {
    _controller.setVolume(volumePercent);
  }

  void _changeScaleMode(YoutubeScaleMode mode) {
    setState(() {
      _mode = mode;
      _controller.changeScaleMode(mode);
    });
  }

  void _changeVolumeMode(bool isMuted) {
    setState(() {
      _isMuted = isMuted;
      if (isMuted) {
        _controller.setMute();
      } else {
        _controller.setUnMute();
      }
    });
  }

  void _changePlaybackRate(PlaybackRate playbackRate) {
    setState(() {
      _playbackRate = playbackRate;
      _controller.setPlaybackRate(rate: _playbackRate);
    });
  }

  SizeConfig screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: FlutterYoutubeView(
                scaleMode: _mode,
                onViewCreated: _onYoutubeCreated,
                listener: this,
                params: YoutubeParam(
                  videoId: widget.id,
                  showUI: true,
                  startSeconds: 0.0,
                  autoPlay: false,
                  showFullScreen: false,
                  showYoutube: false,
                ),
              )),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: screenSize.screenHeight * 2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.screenWidth * 5),
                    child: Text(
                      "About the course",
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: screenSize.screenHeight * 3.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.screenWidth * 5),
                    child: Text(
                      widget.desc,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: screenSize.screenHeight * 2,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.screenWidth * 5),
                    child: Text(
                      "Preview",
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenSize.screenHeight * 3.5,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: screenSize.screenHeight * 25,
                    width: screenSize.screenWidth * 100,
                    child: Padding(
                      padding: EdgeInsets.only(
                          //left: screenSize.screenWidth * 2,
                          right: screenSize.screenWidth * 4),
                      child: ListView.builder(
                          controller: scrollController,
                          //shrinkWrap: true,
                          itemBuilder: (BuildContext cntxt, int index) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: screenSize.screenWidth * 2,
                                    right: screenSize.screenWidth * 2),
                                child: GestureDetector(
                                  onTap: () {
                                    if (widget.previewData[index]['type'] !=
                                        'text') {
                                      print(widget.previewData[index]['content']
                                          .toString());
                                      String link = widget.previewData[index]
                                              ['content']
                                          .toString();
                                      link = link.substring(
                                          link.indexOf('embed/') + 6);
                                      print(link);

                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return CourseVideoScreen(
                                          id: link,
                                          name: widget.name,
                                          desc: widget.desc,
                                          previewData: widget.previewData,
                                        );
                                      }));
                                    } else {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ReadCourseDocScreen(
                                            widget.previewData[index]
                                                ['content'],
                                            widget.previewData[index]['name']);
                                      }));
                                    }
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(
                                        screenSize.screenHeight * 2),
                                    color: Colors.white,
                                    elevation: 3,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: screenSize.screenWidth * 30,
                                      height: screenSize.screenHeight * 25,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            child: Icon(
                                              widget.previewData[index]
                                                          ['type'] !=
                                                      'text'
                                                  ? Icons.personal_video
                                                  : Icons.description,
                                              size: screenSize.screenHeight * 6,
                                              color: Colors.white,
                                            ),
                                            backgroundColor:
                                                ColorList[index % 4],
                                            radius: screenSize.screenHeight * 4,
                                          ),
                                          Container(
                                            height:
                                                screenSize.screenHeight * 15,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      screenSize.screenHeight *
                                                          1,
                                                  horizontal:
                                                      screenSize.screenWidth *
                                                          2),
                                              child: Text(
                                                widget.previewData[index]
                                                    ['name'],
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.previewData.length,
                          padding: EdgeInsets.fromLTRB(
                              0,
                              screenSize.screenHeight * 1,
                              0,
                              screenSize.screenHeight * 1)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildControl() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          color: Colors.black,
          onPressed: _loadOrCueVideo,
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        ),
        RaisedButton(
          color: Colors.black,
          onPressed: _play,
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
        ),
        RaisedButton(
          color: Colors.black,
          onPressed: _pause,
          child: Icon(Icons.pause, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildScaleModeRadioGroup() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          focusColor: Theme.of(context).primaryColor,
          activeColor: Theme.of(context).primaryColor,
          value: YoutubeScaleMode.none,
          groupValue: _mode,
          onChanged: _changeScaleMode,
        ),
        new Text(
          'none',
          style: TextStyle(color: Colors.blue),
        ),
        new Radio(
          focusColor: Theme.of(context).primaryColor,
          activeColor: Theme.of(context).primaryColor,
          value: YoutubeScaleMode.fitWidth,
          groupValue: _mode,
          onChanged: _changeScaleMode,
        ),
        new Text(
          'fitWidth',
          style: TextStyle(color: Colors.blue),
        ),
        new Radio(
          focusColor: Theme.of(context).primaryColor,
          activeColor: Theme.of(context).primaryColor,
          value: YoutubeScaleMode.fitHeight,
          groupValue: _mode,
          onChanged: _changeScaleMode,
        ),
        new Text(
          'fitHeight',
          style: TextStyle(color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildVolume() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: false,
          groupValue: _isMuted,
          onChanged: _changeVolumeMode,
        ),
        new Text(
          'unMute',
          style: TextStyle(color: Colors.blue),
        ),
        new Radio(
          value: true,
          groupValue: _isMuted,
          onChanged: _changeVolumeMode,
        ),
        new Text(
          'Mute',
          style: TextStyle(color: Colors.blue),
        )
      ],
    );
  }

  Widget _buildPlaybackRate() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Speed',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          width: 16,
        ),
        Container(
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                focusColor: Colors.white,
                hoverColor: Colors.white,
                activeColor: Theme.of(context).primaryColor,
                value: PlaybackRate.RATE_0_25,
                groupValue: _playbackRate,
                onChanged: _changePlaybackRate,
              ),
              Text(
                '0_25',
                style: TextStyle(color: Colors.white),
              ),
              new Radio(
                focusColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).primaryColor,
                value: PlaybackRate.RATE_0_5,
                groupValue: _playbackRate,
                onChanged: _changePlaybackRate,
              ),
              new Text(
                '0_5',
                style: TextStyle(color: Colors.white),
              ),
              new Radio(
                focusColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).primaryColor,
                value: PlaybackRate.RATE_1,
                groupValue: _playbackRate,
                onChanged: _changePlaybackRate,
              ),
              new Text(
                '1',
                style: TextStyle(color: Colors.white),
              ),
              new Radio(
                focusColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).primaryColor,
                value: PlaybackRate.RATE_1_5,
                groupValue: _playbackRate,
                onChanged: _changePlaybackRate,
              ),
              new Text(
                '1_5',
                style: TextStyle(color: Colors.white),
              ),
              new Radio(
                focusColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).primaryColor,
                value: PlaybackRate.RATE_2,
                groupValue: _playbackRate,
                onChanged: _changePlaybackRate,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: new Text(
                  '2',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
