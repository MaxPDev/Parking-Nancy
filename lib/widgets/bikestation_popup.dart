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
  }) : _marker = marker,
      // _isBikeMinPopupVisible = isBikeMinPopupVisible,
      super(key: key);

  final Marker _marker;
  // final bool _isBikeMinPopupVisible;

  @override
  State<BikestationPopup> createState() => _BikestationPopupState();
}

class _BikestationPopupState extends State<BikestationPopup> {
  final bikeStations = Provider.of<JcdecauxVelostan>;

  // bool bigPopup = false;

  @override
  Widget build(BuildContext context) {

      Station bikeStation = 
        bikeStations(context, listen: false).getStationFromCoordinates(widget._marker.point);

      Future<void> _initStationDataPopup() async {
        await bikeStations(context, listen: false).
          getStationWithDynamicDataFromCoordinates(widget._marker.point).
          then((value) {
            bikeStation = bikeStations(context, listen: false).selectedStation;
          },);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.yellow
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Titre")
            ],
          ),
          Row(
            children: [
              Text("Velo")
            ],
          ),
          Row(
            children: [
              Text("station")
            ],
          ),
          Row(
            children: [
              Text("CB")
            ],
          ),
          Row(
            children: [
              Text("Adresse")
            ],
          )
        ],
      ),
    );
  }
}



