import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'dart:convert'; // to user jsonDecode
import 'dart:developer';
import 'package:latlong2/latlong.dart';

import 'package:nancy_stationnement/models/parking.dart';

class GnyParking extends ChangeNotifier {
  static List<Parking> _parkingsFromAPI =
      []; //todo: à supprimer pour nourrir directement la bd + getAll depuis la bd
  static List<Parking> _parkings = [];

  List<Marker> _markers = [];

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

      // delete base here for test

      // Créer les objets parkings depuis les données //TODO: transformer à directement dans la DB
      _parkingsFromAPI.clear();
      data.forEach((key, value) {
        _parkingsFromAPI.add(Parking.fromAPIJson(data[key]));
      });
      _parkings = _parkingsFromAPI; //todo: à changer quand database ok

    } catch (e) {
      print('Caught error in GnyParking.fetchDataParking() : $e');
    }
  }

  //
  // Récupère les données dynamiques de parking depuis go.g-ny.org
  // Sotck les données dans la base de données local
  //
  Future<void> fetchDynamicDataParkings() async {
    try {
      //? quand.où remplir le _parking depuis la database ? En attendant
      // Récupère les données via l'API
      var uri = Uri.parse('${uriGny}hot');
      Response response = await get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);

      for (Parking parking in _parkings) {
        //? Autre chose qu'un forEach dans un forEach ?
        data.forEach((key, value) {
          if (parking.id == key) {
            parking.capacity = data[key]["capacity"] == null ? null : int?.parse(data[key]["capacity"].toString());
            parking.available = data[key]["mgn:available"];
            parking.isClosed = data[key]["mgn:closed"];
            parking.colorHexa = data[key]["ui:color"];
            parking.colorText = data[key]["ui:color_en"];
          }
        });
      }
      inspect(_parkings);
    } catch (e) {
      print('Caught error in GnyParking.fetchDynamicDataParking() : $e');
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
    super.removeListener(listener);
    print("removeListener here");
  }
}
