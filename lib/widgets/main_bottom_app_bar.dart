import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nancy_stationnement/services/gny_parking.dart';
import 'package:nancy_stationnement/services/jcdecaux_velostan.dart';

class MainBottomAppBar extends StatefulWidget {
  const MainBottomAppBar({Key? key, required this.onUpdateTap
      // required this.gny,
      })
      : super(key: key);

  final Function onUpdateTap;

  @override
  State<MainBottomAppBar> createState() => _MainBottomAppBarState();
}

class _MainBottomAppBarState extends State<MainBottomAppBar> {
  // final GnyParking Function(BuildContext context, {bool listen}) gny;
  final gny = Provider.of<GnyParking>;

  final bikeStations = Provider.of<JcdecauxVelostan>;

  String selectedButton = "parkings";
  bool selectedRefresh = false;

  @override
  Widget build(BuildContext context) {


    final snackBarParking = SnackBar(
      content: Text("Données des Parkings mis à jour (dev mode)"),
      backgroundColor: Colors.blue,
      elevation: 5,
    );


    return BottomAppBar(
      color: Color.fromARGB(255, 92, 212, 92), //TODO: Global
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print("button");
                }
              },
              icon: const Icon(Icons.directions_walk)),
          IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print("button");
                }
              },
              icon: const Icon(Icons.directions_bus)),
          Container(
            color: selectedButton == "bikestation" ? 
            Color.fromARGB(255, 168, 207, 169) : 
            Color.fromARGB(255, 92, 212, 92),
            child: IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("Velo button pressed");
                  }
                  setState(() {
                    selectedButton = "bikestation";
                  });
                  widget.onUpdateTap("bikeStations");
          
                  
                },
                icon: const Icon(Icons.directions_bike)),
          ),
          Container(
            color: selectedButton == "parkings" ? 
              Color.fromARGB(255, 168, 207, 169) : 
              Color.fromARGB(255, 92, 212, 92),
            child: IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("parking button pressed");
                  }
                  setState(() {
                    selectedButton = "parkings";
                  });
                  widget.onUpdateTap("parkings");
                  // gny(context, listen: false)
                  //     .reInitParkingAndGenerateMarkers()
                  //     .then((value) => {
                  //           print("reInit Parking from P button"),
                  //           onUpdateTap("parkings"),
                  //           ScaffoldMessenger.of(context).showSnackBar(snackBarParking)
                  //         });
                },
                icon: const Icon(Icons.local_parking)),
          ),
          Container(
            color: selectedRefresh ? 
              Color.fromARGB(255, 168, 207, 169) : 
              Color.fromARGB(255, 92, 212, 92),
            child: IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("MAJ Parkings");
                  }
                  setState(() {
                    selectedRefresh = true;
                  });
                  gny(context, listen: false).fetchDynamicDataParkings().then(
                      (value) => {
                            print("fetchDynamicData from MAJ button"),
                            widget.onUpdateTap("parkings"),
                            setState(() {
                              selectedRefresh = false;
                            })
                  });

                  //? Si utilisé, afficher si not null, vider la variable après affichage
                  //? ou créer un tableau. -> gestion d'erreur flutter ? équivalent slim: regarder
                  // ScaffoldMessenger.of(context).showSnackBar(gny(context, listen: false).snackBarError);
                },
                icon: const Icon(Icons.update)),
          ),
        ],
      ),
    );
  }
}
