import 'package:flutter/material.dart';
import 'package:musicapp/colors.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NavBarItem(
            icon: Icons.music_note,
          ),
          Text(
            'Music',
            style: TextStyle(
                fontSize: 20,
                color: darkprimarycol,
                fontWeight: FontWeight.w500),
          ),
          GestureDetector(
            child: NavBarItem(
              icon: Icons.music_video,
            ),
          )
        ],
      ),
    );
  }
}

class NavigationBar1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NavBarItem(
            icon: Icons.music_note,
          ),
          Text(
            'Now Playing',
            style: TextStyle(
                fontSize: 20,
                color: darkprimarycol,
                fontWeight: FontWeight.w500),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: NavBarItem(
              icon: Icons.arrow_back,
            ),
          )
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;

  const NavBarItem({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(boxShadow: [
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
      ], color: primarycol, borderRadius: BorderRadius.circular(10)),
      child: Icon(
        icon,
        color: darkprimarycol,
      ),
    );
  }
}
