import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:indexed/indexed.dart';
// import 'package:latlong2/latlong.dart';

import 'package:nancy_stationnement/models/parking.dart';
import 'package:nancy_stationnement/services/gny_parking.dart';

class ParkingPopup extends StatelessWidget {
  ParkingPopup(
      {Key? key,
      required List<Marker> markers,
      required Marker marker,
      required Map parkingTitle})
      : _markers = markers,
        _marker = marker,
        _parkingTitle = parkingTitle,
        super(key: key);

  final List<Marker> _markers;
  final Marker _marker;
  final Map _parkingTitle;

  late String? available;

  @override
  Widget build(BuildContext context) {
    Parking parking = GnyParking.getParkingFromCoordinates(_marker.point);

    available = GnyParking.getAvailableFromCoordinates(_marker.point);

    // Si la donnée available est à null, un container vide est retournée
    // Sinon, un container est créé pour afficher une popup avec available
    if (available == "null") {
      if (_parkingTitle['all']) {
        return PopupName(parking: parking, marker: _marker, markers: _markers);
      } else {
        return Container();
      }
    } else {
      if (_parkingTitle['three'] &&
          (parking.name == "Place des Vosges" ||
              parking.name == "Manufacture" ||
              parking.name == "Kennedy")) {
        //TODO Global
        return PopupNameAndAvailable(
            parking: parking,
            marker: _marker,
            markers: _markers,
            available: available);
      } else if (_parkingTitle['six'] &&
          (parking.name == "Place Stanislas" ||
              parking.name == "Vaudémont" ||
              parking.name == "Saint-Sébastien")) {
        return PopupNameAndAvailable(
            parking: parking,
            marker: _marker,
            markers: _markers,
            available: available);
      } else if (_parkingTitle['all']) {
        return PopupNameAndAvailable(
            parking: parking,
            marker: _marker,
            markers: _markers,
            available: available);
      } else {
        return PopupAvailable(
            marker: _marker, markers: _markers, available: available);
      }
    }
  }
}

class PopupNameAndAvailable extends StatelessWidget {
  const PopupNameAndAvailable({
    Key? key,
    required this.parking,
    required Marker marker,
    required List<Marker> markers,
    required this.available,
  })  : _marker = marker,
        _markers = markers,
        super(key: key);

  final Parking parking;
  final Marker _marker;
  final List<Marker> _markers;
  final String? available;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      // height: 90,
      // width: 154,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                child: Container(
                  // height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(216, 212, 212, 0.54),
                  ),
                  child: LimitedBox(
                    maxHeight: double.infinity,
                    maxWidth: 100,
                    child: Text("  ${parking.name!}  ",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          Container(
              alignment: Alignment.center,
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: GnyParking.getColorFromCoordinates(_marker.point),
                  shape: BoxShape.circle),
              child: GestureDetector(
                onTap: () => PopupController(
                    initiallySelectedMarkers: _markers), //! ou pas
                child: Text(
                  // penser à mettre à jour ceci, alors que marker sont fixe (mise à jour plus rarement, et ceux affichés doivent être issues de la BD)
                  "${available}",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              )),
        ],
      ),
    );
  }
}

class PopupName extends StatelessWidget {
  const PopupName({
    Key? key,
    required this.parking,
    required Marker marker,
    required List<Marker> markers,
  })  : _marker = marker,
        _markers = markers,
        super(key: key);

  final Parking parking;
  final Marker _marker;
  final List<Marker> _markers;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      // height: 100,
      // width: 154,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                child: Container(
                  // height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(216, 212, 212, 0.54),
                  ),
                  child: LimitedBox(
                    maxHeight: double.infinity,
                    maxWidth: 100,
                    child: Text("  ${parking.name!}  ",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PopupAvailable extends StatelessWidget {
  const PopupAvailable({
    Key? key,
    required Marker marker,
    required List<Marker> markers,
    required this.available,
  })  : _marker = marker,
        _markers = markers,
        super(key: key);

  final Marker _marker;
  final List<Marker> _markers;
  final String? available;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: GnyParking.getColorFromCoordinates(_marker.point),
            shape: BoxShape.circle),
        child: GestureDetector(
          onTap: () =>
              PopupController(initiallySelectedMarkers: _markers), //! ou pas
          child: Text(
            // penser à mettre à jour ceci, alors que marker sont fixe (mise à jour plus rarement, et ceux affichés doivent être issues de la BD)
            "${available}",
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ));
  }
}
