import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicapp/colors.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/navbar.dart';

// ignore: must_be_immutable
class MusicPlayer extends StatefulWidget {
  Function changeTrack;
  SongInfo songInfo;
  final GlobalKey<MusicPlayerState> key;
  MusicPlayer(
      {required this.songInfo, required this.changeTrack, required this.key})
      : super(key: key);
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  // late SongInfo songInfo;

  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    setSong(widget.songInfo);
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  void setSong(SongInfo song) async {
    await player.setUrl(widget.songInfo.uri);
    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarycol,
      body: Column(
        children: [
          NavigationBar1(),
          Container(
              margin: EdgeInsets.fromLTRB(5, 40, 5, 0),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: widget.songInfo.albumArtwork == null
                        ? AssetImage("assets/images/img.jpg")
                        // : FileImage(File(widget.songInfo.albumArtwork))as ImageProvider)
                        : AssetImage("assets/images/img.jpg"),
                    radius: 75,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      widget.songInfo.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 33),
                    child: Text(
                      widget.songInfo.artist,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Slider(
                    inactiveColor: Colors.black12,
                    activeColor: Colors.black,
                    min: minimumValue,
                    max: maximumValue,
                    value: currentValue,
                    onChanged: (value) {
                      log("A");
                      currentValue = value;
                      player.seek(Duration(milliseconds: currentValue.round()));
                    },
                  ),
                  Container(
                    transform: Matrix4.translationValues(0, -15, 0),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(currentTime,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500)),
                        Text(endTime,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(currentTime,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500)),
                          Text(endTime,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500))
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              widget.changeTrack(false);
                            },
                            child: Controls(
                              icon: Icons.skip_previous,
                            ),
                          ),
                          GestureDetector(
                            child: Icon(
                                isPlaying
                                    ? Icons.pause_circle_filled_rounded
                                    : Icons.play_circle_fill_rounded,
                                color: Colors.black,
                                size: 85),
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              changeStatus();
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.changeTrack(true);
                            },
                            child: Controls(
                              icon: Icons.skip_next,
                            ),
                          ),
                        ],
                      ))
                ],
              )),
        ],
      ),
    );
  }
}

class Controls extends StatelessWidget {
  final IconData icon;

  const Controls({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: darkprimarycol,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: darkprimarycol.withOpacity(0.5),
              offset: Offset(5, 10),
              spreadRadius: 3,
              blurRadius: 10),
          BoxShadow(
              color: Colors.white,
              offset: Offset(-3, -4),
              spreadRadius: -2,
              blurRadius: 20)
        ],
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: darkprimarycol.withOpacity(0.5),
                        offset: Offset(5, 10),
                        spreadRadius: 3,
                        blurRadius: 10),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-3, -4),
                        spreadRadius: -2,
                        blurRadius: 20)
                  ]),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: primarycol, shape: BoxShape.circle),
              child: Center(
                  child: Icon(
                icon,
                size: 30,
                color: darkprimarycol,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
