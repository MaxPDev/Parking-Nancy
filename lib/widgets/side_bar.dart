import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:nancy_stationnement/services/gny_parking.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    Key? key,
    required this.updateParking,
  }) : super(key: key);

  final gny = Provider.of<GnyParking>;

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
                color: Color.fromARGB(255, 31, 77, 33),
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
                            style: TextStyle(
                              color: Colors.grey[100],
                              fontSize: 24,
                      
                          ),),
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
                            style: TextStyle(
                              color: Colors.grey[100],
                              fontSize: 24,
                      
                          ),),
                        ],
                      )
                    ],
                  ),
                ],
              )
            ),
          ),
          ListTile(
            title: Text("Mettre à jour les informations des parkings"),
            subtitle: Text("Met à jour les nombres de place pour personne à mobilité réduite, les places avec borne de recharge electrique, les tarifs et autres informations. \nUne pression sur le bouton P rafraichit seulement le nombre de places restantes dans les parkings."),
            onTap: () {
              updateParking();
              Scaffold.of(context).closeDrawer();
              
              // gny(context, listen: false).reInitParkingAndGenerateMarkers()
              // .then((value) {
              // },);
            },
          ),
          ListTile(
            title: Text("À propos"),
            subtitle: Text("Mentions légales\nLibrairies Open Source\nVersion"),
          ),
        ],
      ),
    );
  }
}