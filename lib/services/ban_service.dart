import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BanService extends ChangeNotifier {

  // URI de la Base Adresse Nationale
  String uriBan = 'api-adresse.data.gouv.fr/search/?q=';

  // Les recherches s'effectue depuis ce point en priorité
  String geoPriority = '&lat=48.69078&lon=6.182468';

  BanService() {
    if (kDebugMode) {
      print("Ban serivce constructor")
  
    }
  }

  Future<void> fetchDataAdresseFromInput() async {
    // Récupère les données via l'API
    var uri = Uri.parse('${uriBan}22+ru+aristi+brian${geoPriority}');
    Response response = await get(uri);
    Map<String, dynamic> data = jsonDecode(response.body);

    inspect(data);
  }
}

