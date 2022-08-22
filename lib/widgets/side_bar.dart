import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:nancy_stationnement/services/gny_parking.dart';
import 'package:nancy_stationnement/services/global_text.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    Key? key,
    required this.updateParking,
  }) : super(key: key);

  final gny = Provider.of<GnyParking>;
  final text = Provider.of<GlobalText>;

  final Function updateParking;

  @override
  Widget build(BuildContext context) {

    // final snackBarParking = SnackBar(
    //   content: Text("Données des Parkings mis à jour"),
    //   backgroundColor: Colors.blue,
    //   elevation: 5,
    // );

    return Drawer(
      // backgroundColor: Colors.green[200],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(21)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        width: 70,
                        height: 70,
                        image: AssetImage('assets/images/logo.png'),
                        )
                    ],
                  ),
                  SizedBox(
                    width: 54,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Parking",
                            style: Theme.of(context).textTheme.headline1
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Nancy",
                            style: Theme.of(context).textTheme.headline1
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )
            ),
          ),
          ListTile(
            title: Text(
              text(context, listen: false).parkingUpdate,
              style: Theme.of(context).textTheme.bodyText1),
            subtitle: Text(
              text(context, listen: false).parkingUpdateDescr,
              // style: Theme.of(context).textTheme.bodyText1,  
            ),
            onTap: () {
              updateParking();
              Scaffold.of(context).closeDrawer();
              
              // gny(context, listen: false).reInitParkingAndGenerateMarkers()
              // .then((value) {
              // },);
            },
          ),
          ListTile(
            title: Text(text(context, listen: false).aboutTitle),
            subtitle: Text(text(context, listen: false).aboutDescr),
          ),
        ],
      ),
    );
  }
}