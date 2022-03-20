// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicapp/colors.dart';
import 'package:musicapp/music_player.dart';
import 'package:musicapp/navbar.dart';

class Track extends StatefulWidget {
  Track({Key? key}) : super(key: key);

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  int currentIndex = 0;
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();
  void initState() {
    super.initState();
    gettracks();
  }

  void gettracks() async {
    songs = await audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != songs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState!.setSong(songs[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primarycol,
        body: Column(
          children: [
            NavigationBar(),
            new Expanded(
              child: ListView.separated(
                  // itemBuilder: (context, index) => ListTile(
                  //       leading: CircleAvatar(
                  //           backgroundImage: songs[index].albumArtwork == null
                  //               ? AssetImage("assets/images/img.jpg")
                  //               : AssetImage("assets/images/img.jpg")),
                  //       title: Text(songs[index].title),
                  //       subtitle: Text(songs[index].artist),
                  //       onTap: () {
                  //         currentIndex = index;
                  //         Navigator.of(context).push(MaterialPageRoute(
                  //             builder: (context) => MusicPlayer(
                  //                 changeTrack: changeTrack,
                  //                 songInfo: songs[currentIndex],
                  //                 key: key)));
                  //       },
                  //     ),
                  itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        currentIndex = index;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MusicPlayer(
                                changeTrack: changeTrack,
                                songInfo: songs[currentIndex],
                                key: key)));
                      },
                      child: Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "assets/images/img.jpg",
                                fit: BoxFit.fill,
                              )),
                          decoration: BoxDecoration(
                            color: primarycol,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: darkprimarycol,
                                  offset: Offset(20, 8),
                                  spreadRadius: 3,
                                  blurRadius: 25),
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-3, -4),
                                  spreadRadius: -2,
                                  blurRadius: 20)
                            ],
                          ))),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: songs.length),
            ),
          ],
        ));
  }
}
