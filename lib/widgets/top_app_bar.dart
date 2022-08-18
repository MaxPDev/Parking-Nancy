import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import 'package:nancy_stationnement/services/ban_service.dart';

class TopAppBar extends StatefulWidget implements PreferredSizeWidget {
  TopAppBar({
    Key? key,
    // required this.onExpansionComplete
    required this.onEdition,
    required this.onClose,
  }) : super(key: key);

  final Function onEdition;
  final Function onClose;

  @override
  State<TopAppBar> createState() => _TopAppBarState();
  
  @override
  // // TODO: implement preferredSize
  // Size get preferredSize => throw UnimplementedError();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopAppBarState extends State<TopAppBar> {
  final ban = Provider.of<BanService>;

  final textController = TextEditingController();

  static String textSave = "";

  // Note: This is a `GlobalKey<FormState>`,
  @override
  Widget build(BuildContext context) {


    // Variables de hauteurs d'écrans
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double height1 = height - padding.top - padding.bottom;

    // Height (without status bar)
    double height2 = height - padding.top;

    // Height (without status and toolbar)
    double height3 = height - padding.top - kToolbarHeight;

    return AppBar(
      leading: IconButton(
        // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        icon: Icon(Icons.menu),
        onPressed: () {
          // widget.onMenu();
          Scaffold.of(context).openDrawer();
        },
      ),
      //TODO: make and use global var/settings
      title: Text(
        "Parking Nancy",
        // style: TextStyle(fontSize: 18, overflow: TextOverflow.visible),
        style: Theme.of(context).textTheme.headline2,
      ),
      // centerTitle: true,
      // backgroundColor: Color.fromARGB(255, 31, 77, 33),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
          child: Form(
            child: SearchBarAnimation(
              textInputType: TextInputType.streetAddress,
              enableKeyboardFocus: true,
              textEditingController: textController,
              durationInMilliSeconds: 421,
              isOriginalAnimation: false,
              hintText: "Destination...",
              searchBoxWidth: width * 0.70,
              enableBoxBorder: true,
              enableBoxShadow: true,
              // enableButtonBorder: true,
              // enableButtonShadow: true,

              // onExpansionComplete: onEdition,
              

              onChanged: (String? value) {
                if (kDebugMode) {
                  print("on changed $value");
                }

                if (value != null && value.length > 3) {
                  ban(context, listen: false).initAddress(value.trim().replaceAll(' ', '+'));
                  if (value.length > 5) {
                  textSave = value;
                  widget.onEdition();
                  textController.text = textSave;
                  textController.selection = TextSelection.collapsed(offset: textSave.length);
                  }
                }

              },

              onSaved: (String? value) {
                if (kDebugMode) {
                  print("Saved now $value");
                }
              },

              // onEditingComplete: (String? value) {
              //   if (kDebugMode) {
              //     print("EditingComplete now $value");
              //   }
              // },

              onFieldSubmitted: (String? value) {
                if (kDebugMode) {
                  print("onfieldsubmitted now $value");
                }

                if (value != null) {
                  ban(context, listen: false).initAddress(value.trim().replaceAll(' ', '+'));
                }
              },

              onCollapseComplete: () {
                widget.onClose();
              },
              
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              icon: Icon(Icons.location_searching, color: Colors.white),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {},
            )),
      ],
      actionsIconTheme:
          IconThemeData(size: 10.0, color: Colors.white, opacity: 0.7),
      elevation: 7.0,
    );
  }
}
