import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'dart:convert'; // to user jsonDecode
import 'dart:developer';
import 'package:latlong2/latlong.dart';

import 'package:nancy_stationnement/models/parking.dart';
import 'package:nancy_stationnement/database/parking_database.dart';

class GnyParking extends ChangeNotifier {
  static List<Parking> _parkingsFromAPI = []; //todo: à supprimer pour nourrir directement la bd + getAll depuis la bd
  static List<Parking> _parkings = [];

  static List<Marker> _markers = [];

  String uriGny =
      'https://go.g-ny.org/stationnement?output='; //TODO: Global uriGny

  GnyParking() {
    print("GnyParking constructor");
  }

  //
  // Récupère les données de parking depuis go.g-ny.org
  // Sotck les données dans la base de données local
  //
  Future<void> fetchDataParkings() async {
    try {
      // Récupère les données via l'API
      var uri = Uri.parse('${uriGny}json');
      Response response = await get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);

      
      await ParkingDatabase.instance.deleteDatabase('parkings.db');


      // Créer les objets parkings depuis les données //TODO: transformer à directement dans la DB
      _parkingsFromAPI.clear();
      data.forEach((key, value) async {
        // _parkingsFromAPI.add(Parking.fromAPIJson(data[key]));
        var id = await ParkingDatabase.instance.createParking(Parking.fromAPIJson(data[key]));
      });
      // await parkingsToDatabase();
      inspect(_parkingsFromAPI);
      // _parkings = _parkingsFromAPI; //todo: à changer quand database ok
      _parkings = await ParkingDatabase.instance.getAllParking();

      inspect(_parkings);

    } catch (e) {
      //todo : remonter les erreurs dans un affichage user
      print('Caught error in GnyParking.fetchDataParking() : $e');
    }
  }



  Future parkingsToDatabase() async {
    _parkingsFromAPI.forEach((parking) async {
        var id = await ParkingDatabase.instance.createParking(parking);
        print(id);
    });
  }

  //
  // Récupère les données dynamiques de parking depuis go.g-ny.org
  //
  Future<void> fetchDynamicDataParkings() async {
    try {
      // Récupère les données via l'API
      var uri = Uri.parse('${uriGny}hot');
      Response response = await get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);

      // Met à jour les objets parkings avec les nouvelles données
      for (Parking parking in _parkings) {
        data.forEach((key, value) {
          if (parking.id == key) {
            parking.capacity = data[key]["capacity"] == null
                ? null
                : int?.parse(data[key]["capacity"].toString());
            parking.available = data[key]["mgn:available"];
            parking.isClosed = data[key]["mgn:closed"];
            parking.colorHexa = data[key]["ui:color"];
            parking.colorText = data[key]["ui:color_en"];
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Caught error in GnyParking.fetchDynamicDataParking() : $e');
      }
    }
  }

  //
  // Construit les marker depuis les objets parking
  //
  void generateParkingMarkers() {
    List<Marker> markers = [];
    for (var parking in _parkings) {
      //todo récupérer depuis db
      markers.add(Marker(
          point: LatLng(parking.coordinates[1],
              parking.coordinates[0]), //? refaire en parking.lat et.long ?
          width: 30,
          height: 30,
          builder: (context) => Icon(
                FontAwesomeIcons.squareParking,
                size: 30,
                color: Colors.blueAccent,
              )));
    }
    _markers = markers;
  }

  // Renvoie les la liste des markers
  List<Marker> getParkingsMarkers() {
    return _markers;
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
    super.removeListener(listener);
    print("removeListener here");
  }
}
