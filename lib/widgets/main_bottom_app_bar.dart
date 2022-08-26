import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nancy_stationnement/services/store.dart';
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
  final store = Provider.of<Store>;
  final gny = Provider.of<GnyParking>;
  final bikeStations = Provider.of<JcdecauxVelostan>;

  String selectedButton = "parkings";
  bool selectedRefresh = false;

  @override
  Widget build(BuildContext context) {

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Container(
          //   // color: Colors.grey,
          //   child: IconButton(
          //       onPressed: () {
          //         if (kDebugMode) {
          //           print("pedestran button");
          //         }
          //       },
          //       icon: const Icon(Icons.directions_walk)),
          // ),
          // Container(
          //   // color: Colors.grey,
          //   child: IconButton(
          //       onPressed: () {
          //         if (kDebugMode) {
          //           print("bus button");
          //         }
          //       },
          //       icon: const Icon(Icons.directions_bus)),
          // ),
          // Container(
          //   // color: Colors.grey,
          //   child: IconButton(
          //       onPressed: () {
          //         if (kDebugMode) {
          //           print("warning button");
          //         }
          //       },
          //       icon: const Icon(Icons.warning)),
          // ),
          // // Container(
          // //   // color: Colors.grey,
          // //   child: IconButton(
          // //       onPressed: () {
          // //         if (kDebugMode) {
          // //           print("charging station button");
          // //         }
          // //       },
          // //       icon: const Icon(Icons.charging_station)),
          // // ),
          Container(
            color: selectedButton == "bikestation" ? 
              Theme.of(context).primaryColorLight :
              Theme.of(context).primaryColor,
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
              Theme.of(context).primaryColorLight :
              Theme.of(context).primaryColor,
            child: IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("parking button pressed");
                  }

                  setState(() {
                    //? Relier au provider ?
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
          // Container(
          //   color: selectedRefresh ? 
          //     Color.fromARGB(255, 168, 207, 169) : 
          //     Color.fromARGB(255, 92, 212, 92),
          //   child: IconButton(
          //       onPressed: () {
          //         if (kDebugMode) {
          //           print("MAJ Parkings");
          //         }
          //         setState(() {
          //           selectedRefresh = true;
          //         });
          //         gny(context, listen: false).fetchDynamicDataParkings().then(
          //             (value) => {
          //                   print("fetchDynamicData from MAJ button"),
          //                   widget.onUpdateTap("parkings"),
          //                   setState(() {
          //                     selectedRefresh = false;
          //                   })
          //         });

          //         //? Si utilisé, afficher si not null, vider la variable après affichage
          //         //? ou créer un tableau. -> gestion d'erreur flutter ? équivalent slim: regarder
          //         // ScaffoldMessenger.of(context).showSnackBar(gny(context, listen: false).snackBarError);
          //       },
          //       icon: const Icon(Icons.update)),
          // ),
        ],
      ),
    );
  }
}
