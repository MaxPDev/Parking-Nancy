import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
// import 'package:latlong2/latlong.dart';

import 'package:nancy_stationnement/models/station.dart';
import 'package:nancy_stationnement/services/jcdecaux_velostan.dart';
import 'package:nancy_stationnement/widgets/items.dart';
import 'package:provider/provider.dart';

class BikestationPopup extends StatefulWidget {
  const BikestationPopup({
    Key? key,
    required Marker marker,
    // required bool isBikeMinPopupVisible
  })  : _marker = marker,
        // _isBikeMinPopupVisible = isBikeMinPopupVisible,
        super(key: key);

  final Marker _marker;
  // final bool _isBikeMinPopupVisible;

  @override
  State<BikestationPopup> createState() => _BikestationPopupState();
}

class _BikestationPopupState extends State<BikestationPopup> {
  final bikeStations = Provider.of<JcdecauxVelostan>;

  //? Mettre SizedBox partout pour continer Text avec maxLines au cas où ?

  @override
  Widget build(BuildContext context) {
    Station bikeStation = bikeStations(context, listen: false)
        .getStationFromCoordinates(widget._marker.point);

    Future<void> _initStationDataPopup() async {
      await bikeStations(context, listen: false)
          .getStationWithDynamicDataFromCoordinates(widget._marker.point)
          .then(
        (value) {
          bikeStation = bikeStations(context, listen: false).selectedStation;
        },
      );
    }

    return StationPopup(bikeStation: bikeStation);
  }
}

class StationPopup extends StatelessWidget {
  const StationPopup({
    Key? key,
    required this.bikeStation,
  }) : super(key: key);

  final Station bikeStation;

  // Traite le texte de titre pour enlever le numéro de station et la mention "CB"
  String bikeStationNameToShorter(name) {
    if (name.indexOf("(CB") == -1) {
      return name.substring(8).trim();
    }
    return name.substring(
      8, 
      name.indexOf("(CB)")
    );
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 200,
      width: 300,
      child: Container(
        // constraints: BoxConstraints(maxWidth: 300, maxHeight: 200),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        // width: 400,
        // height: 200,
        decoration: BoxDecoration(color: Color.fromRGBO(210, 255, 197, 0.9)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bikeStationNameToShorter(bikeStation.name),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )
              ],
            ),
            
            Row(
              children: [
                Icon(FontAwesomeIcons.bicycle, color: Colors.black, size: 16),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "${bikeStation.bikes} ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "vélos disponibles",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            Row(
              children: [
                Icon(FontAwesomeIcons.checkToSlot,
                    color: Colors.black, size: 16),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "${bikeStation.stands} ",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "emplacements disponibles",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                )
              ],
            ),
            bikeStation.banking
                ? Row(
                    children: [
                      Icon(FontAwesomeIcons.creditCard,
                          color: Colors.black, size: 16),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Paiement par carte bancaire disponible",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      )
                    ],
                  )
                : Container(),
            Row(
              children: [
                Icon(FontAwesomeIcons.house,
                    color: Colors.black, size: 16),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 240,
                  child: Text(
                    "${bikeStation.address}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                    maxLines: 3,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
