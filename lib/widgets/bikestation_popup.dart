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
    Station bikeStation = bikeStations(context, listen: false).getStationFromCoordinates(_marker.point);
    inspect(bikeStation);

    return Container(child: Text("Velo Popup"));
  }
}
