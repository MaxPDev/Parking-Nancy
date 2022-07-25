import 'dart:convert';
import 'dart:developer';
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';

class JcdecauxVelostan extends ChangeNotifier {
  // https://developer.jcdecaux.com/#/opendata/vls?page=dynamic&contract=nancy

  // URI API JCdecaux
  String uriJcdecaux = "https://api.jcdecaux.com/vls/v3/stations";
  
  // Nom du contrat (correspond à la ville)
  String contractName = "nancy";

  // API Key
  String apiKey = "526c2bc0188fdb797a47511c029cec761757a838";

  JcdecauxVelostan() {
    if (kDebugMode) {
      print("JCdecauxVelostan constructor")
    }
  }

  Future<Map<String, dynamic>> fetchDataStations() async {
    try {
      // Récupère les données via l'API
      var uri = Uri.parse('$uriJcdecaux?contract=$contractName&apiKey=$apiKey');
      Response response = await get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);

      return data;
    } catch (e) {
      if (kDebugMode) {
        print('Caught error in fetchDataStation() : $e');
      }
      rethrow;
    }
  }

  Future<void> fetchDynamicDataStation(String stationNumber) async {
    try {
      var uri = Uri.parse('$uriJcdecaux/$stationNumber?contract=$contractName&apiKey=$apiKey');
      Response response = await get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);

      inspect(data);
    } catch(e) {
      if (kDebugMode) {
        print('Caught error in fetchDynamicDataStation() : $e');
      }
    }
  }
}