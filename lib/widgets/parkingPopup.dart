import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
// import 'package:latlong2/latlong.dart';

import 'package:nancy_stationnement/services/gny_parking.dart';

class ParkingPopup extends StatelessWidget {
  const ParkingPopup({
    Key? key,
    required List<Marker> markers,
    required Marker marker
  }) : _markers = markers, _marker = marker, super(key: key);

  final List<Marker> _markers;
  final Marker _marker;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color:
                GnyParking.getColorFromCoordinates(_marker.point),
            shape: BoxShape.circle),
        child: GestureDetector(
          onTap: () => PopupController(
              initiallySelectedMarkers:
                  _markers), //! ou pas
          child: Text(
            // penser à mettre à jour ceci, alors que marker sont fixe (mise à jour plus rarement, et ceux affichés doivent être issues de la BD)
            "${GnyParking.getAvailableFromCoordinates(_marker.point)}",
            style: TextStyle(
                color: Colors.white, fontSize: 10),
          ),
        ));
  }
}