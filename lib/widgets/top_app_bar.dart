import 'package:flutter/material.dart';

import 'package:searchbar_animation/searchbar_animation.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TopAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        icon: Icon(Icons.menu),
        onPressed: () {},
      ),
      //TODO: make and use global var/settings
      title: const Text(
        "Nancy Stationnement",
        style: TextStyle(
          fontSize: 18,
          overflow: TextOverflow.visible
        ),
      ),
      // centerTitle: true,
      backgroundColor: Color.fromARGB(255, 31, 77, 33),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
          child: SearchBarAnimation(
            textEditingController: TextEditingController(), 
            isOriginalAnimation: false),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: IconButton(
            icon: Icon(
              Icons.location_searching,
              color: Colors.white),
            iconSize: 30,
            color: Colors.white,
            onPressed: () {},
          )
        ),
      ],
      actionsIconTheme: IconThemeData(
        size: 10.0,
        color: Colors.white,
        opacity: 0.7
      ),
      elevation: 7.0,
    );
  }
}