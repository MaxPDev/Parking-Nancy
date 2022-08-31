import 'dart:convert';
import 'dart:developer';
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';

import 'package:nancy_stationnement/models/address.dart';

import 'package:nancy_stationnement/config/services_config.dart' as config;

class BanService extends ChangeNotifier {

  /// Liste des adresses suggérées
  List<Address> addressList = [];

  /// Adresse selectionné par l'utilisateur
  Address? selectedDestinationAddress;

  /// Marqueur de l'adresse sélectionné par l'utilisateur
  Marker? selectedDestinationMarker;

  BanService() {
    if (kDebugMode) {
      print("Ban serivce constructor");
    }
  }

  /// Récupérer les données depuis la saisie, vider la liste des adresse, 
  /// et générer les objets Address en les ajoutant à la liste
  Future<void> initAddress(String? value) async {
    if (value != null && value.length > 2 ) {
      var data = await fetchDataAdresseFromInput(value);
      addressList.clear();
      dataToAddressList(data);
      notifyListeners();

    }

  }  

  /// Effectue la requête à l'API depuis la saisie de l'utilisateur
  Future<Map<String, dynamic>> fetchDataAdresseFromInput(String? address) async {
    try {
      // Récupère les données via l'API
      var uri = Uri.parse('${config.banUriFromAddress}$address${config.banGeoPriority}');
      Response response = await get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);

      return data;
    } catch (e) {
      if (kDebugMode) {
        print('Caught error in fetchDataAdressFromInput() : $e');
      }
      rethrow; //? gérer si null au lieu de ça ?
    }
  }

  /// Conversion des données reçu en liste d'objet Address
  Future<void> dataToAddressList(Map<String, dynamic> data) async {
      for (var i = 0; i < data["features"].length; i++) {
        addressList.add(
          Address.fromAPIJson(data['features'][i])
        );
      }
        inspect(addressList);
  }

  /// Récupère une adresse depuis l'API dà partir de coordonnées fournies [coordinates]
  Future<void> fetchAddressFromCoordinates(String coordinates) async {
    try {
      var uri = Uri.parse('${config.banUriFromAddress}$coordinates${config.banGeoPriority}');
      Response response = await get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);

      inspect(data);
    } catch (e) {
      if (kDebugMode) {
        print('Caught error in fetchAddressFromCoordinates() : $e');
      }
    }
  }

  /// Création du marqueur de l'adresse
  void generateDistinationAdresseMarker() {
    selectedDestinationMarker = Marker(
      key: const ObjectKey("address_marker"),
      point: LatLng(selectedDestinationAddress!.lat, selectedDestinationAddress!.long), 
      width: 40,
      height: 40,
      builder: (context) => const Icon( //? gesturedocore pour faire apparait l'adresse dans la barre de recherche, ou afficher détail de l'adresse ?
        FontAwesomeIcons.locationPin,
        size: 40,
        color: Colors.orange,
       )
      
      );

    inspect(selectedDestinationMarker);
  }


  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
    super.removeListener(listener);
    if (kDebugMode) {
      print("removeListener here");
    }
  }
}
