import 'dart:convert';
import 'dart:developer';
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart';

import 'package:nancy_stationnement/models/station.dart';
import 'package:nancy_stationnement/utils/marker_with_value.dart';

class JcdecauxVelostan extends ChangeNotifier {
  // https://developer.jcdecaux.com/#/opendata/vls?page=dynamic&contract=nancy

  // URI API JCdecaux
  String uriJcdecaux = "https://api.jcdecaux.com/vls/v3/stations";
  
  // Nom du contrat (correspond à la ville)
  String contractName = "nancy";

  // API Key
  String apiKey = "526c2bc0188fdb797a47511c029cec761757a838";

  List<Station> stationList = [];

  List<Marker> stationMarkers = [];
  
  late Station selectedStation;

  JcdecauxVelostan() {
    if (kDebugMode) {
      print("JCdecauxVelostan constructor");
    }
  }

  Future<void> initStations() async {
    String data = await fetchDataStations();
    stationList = stationFromMap(data);
    notifyListeners();
    // inspect(stationList);
  }
  
  List<Station> stationFromMap(String str) 
    => List<Station>.from(json.decode(str).map((x) => Station.fromAPIJson(x)));

  Future<String> fetchDataStations() async {
    try {
      // Récupère les données via l'API
      var uri = Uri.parse('$uriJcdecaux?contract=$contractName&apiKey=$apiKey');
      Response response = await get(uri);
      // String data = jsonDecode(response.body);
      String data = response.body;
      
      return data;
    } catch (e) {
      if (kDebugMode) {
        print('Caught error in fetchDataStation() : $e');
      }
      rethrow;
    }
  }

  Future<void> fetchDynamicDataStation(int stationNumber) async {
    try {
      var uri = Uri.parse('$uriJcdecaux/$stationNumber?contract=$contractName&apiKey=$apiKey');
      Response response = await get(uri);
      var data = jsonDecode(response.body);

      stationList.firstWhere((station) => station.id == stationNumber).bikes = data['totalStands']['availabilities']['bikes'];
      stationList.firstWhere((station) => station.id == stationNumber).stands = data['totalStands']['availabilities']['stands'];

      inspect(stationList);

    } catch(e) {
      if (kDebugMode) {
        print('Caught error in fetchDynamicDataStation() : $e');
      }
      rethrow;
    }
  }

  //
  // Construit les markers depuis les objets station
  //
  void generateStationsMarker() {
    List<Marker>markers = [];
    for (Station station in stationList) {
      markers.add(
        Marker(
          key: const ObjectKey("bikeStation_marker"), //?vlue key avec type + id, pour parse le début quand besoin de détecter le type ?
          // objectId: station.id,
          // key: ValueKey("bikeStation_${station.id}"),
          point: LatLng(
            station.lat,
            station.long
          ),
          width: 30,
          height: 30,
          builder: (context) => Icon(
            FontAwesomeIcons.bicycle,
            size: 30,
            color: Color.fromARGB(255, 9, 148, 81),
          )
        )
      );
    }
    stationMarkers = markers;
    inspect(stationMarkers);
  }


  // Récupère un station depuis les coordoonées
  //! Contournement
  Future<void> getStationWithDynamicDataFromCoordinates(LatLng point) async {
    //? singlewhere ou firstWhere ?
    int stationID = stationList.singleWhere((station) =>
    station.lat == point.latitude &&
    station.long == point.longitude).id;

    await fetchDynamicDataStation(stationID);

    selectedStation = stationList.singleWhere((station) => station.id == stationID);

  }

}