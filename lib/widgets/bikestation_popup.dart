import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
// import 'package:latlong2/latlong.dart';

import 'package:nancy_stationnement/models/station.dart';
import 'package:nancy_stationnement/services/jcdecaux_velostan.dart';

class BikestationPopup extends StatelessWidget {
  const BikestationPopup({
    Key? key,
    dynamic bikeStationId
  }) : _bikeStationId = bikeStationId, super(key: key);

  final dynamic _bikeStationId;

  @override
  Widget build(BuildContext context) {
    inspect(key);
    inspect(_bikeStationId);
    return Container(child: Text("Velo Popup"),);
  }
}
