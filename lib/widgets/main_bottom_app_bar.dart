import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nancy_stationnement/services/gny_parking.dart';
import 'package:nancy_stationnement/services/jcdecaux_velostan.dart';

class MainBottomAppBar extends StatelessWidget {
  const MainBottomAppBar({Key? key, required this.onUpdateTap
      // required this.gny,
      })
      : super(key: key);

  // final GnyParking Function(BuildContext context, {bool listen}) gny;
  // Providers
  final gny = Provider.of<GnyParking>;
  final bikeStations = Provider.of<JcdecauxVelostan>;

  final Function onUpdateTap;

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
          IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print("Velo button pressed");
                }
                onUpdateTap("bikeStations");

                
              },
              icon: const Icon(Icons.directions_bike)),
          IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print("parking button pressed");
                }
                gny(context, listen: false)
                    .reInitParkingAndGenerateMarkers()
                    .then((value) => {
                          print("reInit Parking from P button"),
                          onUpdateTap("parkings"),
                          ScaffoldMessenger.of(context).showSnackBar(snackBarParking)
                        });
              },
              icon: const Icon(Icons.local_parking)),
          IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print("MAJ Parkings");
                }
                gny(context, listen: false).fetchDynamicDataParkings().then(
                    (value) => {
                          print("fetchDynamicData from MAJ button"),
                          onUpdateTap("parkings")
                });

                //? Si utilisé, afficher si not null, vider la variable après affichage
                //? ou créer un tableau. -> gestion d'erreur flutter ? équivalent slim: regarder
                // ScaffoldMessenger.of(context).showSnackBar(gny(context, listen: false).snackBarError);
              },
              icon: const Icon(Icons.update)),
        ],
      ),
    );
  }
}
