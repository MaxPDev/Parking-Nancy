import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
// import 'package:latlong2/latlong.dart';

import 'package:nancy_stationnement/models/station.dart';
import 'package:nancy_stationnement/services/jcdecaux_velostan.dart';
import 'package:provider/provider.dart';

class BikestationPopup extends StatelessWidget {
  const BikestationPopup({
    Key? key,
    required Marker marker
  }) : _marker = marker, 
      super(key: key);

  final Marker _marker;

  final bikeStations = Provider.of<JcdecauxVelostan>;

  @override
  Widget build(BuildContext context) {
    Station bikeStation = 
      new Station(id: 0, name: "", address: "", long: 0, lat: 0, status: "", banking: false);

    Future<void> _initStationDataPopup() async {
      await bikeStations(context, listen: false).
        getStationWithDynamicDataFromCoordinates(_marker.point).
        then((value) {
          bikeStation = bikeStations(context, listen: false).selectedStation;
        },);
    }

    // bikeStations(context, listen: false).getStationWithDynamicDataFromCoordinates(_marker.point).then((value) {
    //   bikeStation = bikeStations(context, listen: false).selectedStation;
    // });

    // futurebuilder

    inspect(bikeStation);
    return Column(
      //TODO: Rattrape le mauvaise placement de la popup : center au lieu de markerTop
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => inspect(bikeStation),
          child: FutureBuilder(
            future : _initStationDataPopup(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Main Error: ${snapshot.error}');
              }

              return StationPopup(bikeStation: bikeStation);
            }
          )
        )
      ],
    );

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
    return SimpleDialog(
      backgroundColor: Color.fromARGB(255, 161, 219, 176),
      title: Text(
        "${bikeStation.name}",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        SimpleDialogOption(
          child: Text(
            "Velo disponible : ${bikeStation.bikes}",
            style: TextStyle(color: Colors.black),
          ),
        ),
        SimpleDialogOption(
          child: Text("Emplacements libre : ${bikeStation.stands}"),
        )
      ],
    );
  }
}
