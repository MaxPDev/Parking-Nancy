import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BanService extends ChangeNotifier {

  // URI de la Base Adresse Nationale
  String uriBanFromAddress = 'api-adresse.data.gouv.fr/search/?q=';

  // Les recherches s'effectue depuis ce point en priorité
  String geoPriority = '&lat=48.69078&lon=6.182468';

  // Recherche depuis des coordonnées (Géolocalisation)
  String uriBanFromCoordinates = 'https://api-adresse.data.gouv.fr/reverse/?';

  BanService() {
    if (kDebugMode) {
      print("Ban serivce constructor")
  
    }
  }

  Future<void> fetchDataAdresseFromInput(String address) async {
    //? Taiter address avant ?
    // Récupère les données via l'API
    var uri = Uri.parse('$uriBanFromAddress$address$geoPriority');
    Response response = await get(uri);
    Map<String, dynamic> data = jsonDecode(response.body);

    inspect(data);
  }

  Future<void> fetchAddressFromCoordinates(String coordinates) async {
    //? Taiter coordinates avant dans autres fonction ?
    // Récupère les données via l'API
    var uri = Uri.parse('$uriBanFromAddress$coordinates$geoPriority');
    Response response = await get(uri);
    Map<String, dynamic> data = jsonDecode(response.body);

    inspect(data);
  }

  //TODO: Marker generator
}

