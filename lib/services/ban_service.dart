import 'dart:convert';
import 'dart:developer';
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';

import 'package:nancy_stationnement/models/address.dart';

class BanService extends ChangeNotifier {
  // URI de la Base Adresse Nationale
  String uriBanFromAddress = 'https://api-adresse.data.gouv.fr/search/?q=';

  // Les recherches s'effectue depuis ce point en priorité
  String geoPriority = '&lat=48.69078&lon=6.182468';

  // Recherche depuis des coordonnées (Géolocalisation)
  String uriBanFromCoordinates = 'https://api-adresse.data.gouv.fr/reverse/?';

  List<Address> addressList = [];
  Address? selectedDestinationAddress;
  late Marker selectedDestinationMarker;

  BanService() {
    if (kDebugMode) {
      print("Ban serivce constructor");
    }
  }

  // Récupérer les données depuis la saisie, vider la liste des adresse, 
  // et générer les objets Address en les ajoutant à la liste
  Future<void> initAddress(String? value) async {
    var data = await fetchDataAdresseFromInput(value);
    addressList.clear();
    dataToAddressList(data);
    notifyListeners();

  }  

  Future<Map<String, dynamic>> fetchDataAdresseFromInput(String? address) async {
    try {
      //? Taiter address avant ?
      // Récupère les données via l'API
      var uri = Uri.parse('$uriBanFromAddress$address$geoPriority');
      Response response = await get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);

      return data;
      //TODO inspect avec inspect la récupération avec les index de tableau
      //TODO bien penser les fonctions de ce fichier (créer objets etc, séparer)
      //TODO créer les objets, les stocker
      //TODO faire la liste de suggestion
      //TODO faire une variable de selection
      //TODO afficher le marquer
      //TODO zoomer sur lui
      //TODO bouton ajouter départ

      //TODO faire géoloc

      //TODO input field number typed first doesn't work
    } catch (e) {
      if (kDebugMode) {
        print('Caught error in fetchDataAdressFromInput() : $e');
      }
      rethrow; //todo gérer si null au lieu de ça ?
    }
  }

  Future<void> dataToAddressList(Map<String, dynamic> data) async {
      for (var i = 0; i < data["features"].length; i++) {
        addressList.add(
          Address.fromAPIJson(data['features'][i])
        );
      }
        inspect(addressList);
  }

  Future<void> fetchAddressFromCoordinates(String coordinates) async {
    try {
      //? Taiter coordinates avant dans autres fonction ?
      // Récupère les données via l'API
      var uri = Uri.parse('$uriBanFromAddress$coordinates$geoPriority');
      Response response = await get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);

      inspect(data);
    } catch (e) {
      if (kDebugMode) {
        print('Caught error in fetchAddressFromCoordinates() : $e');
      }
    }
  }

  //TODO: Marker generator

  void generateDistinationAdresseMarker() {
    selectedDestinationMarker = new Marker(
      point: LatLng(selectedDestinationAddress!.lat, selectedDestinationAddress!.long), 
      width: 40,
      height: 40,
      builder: (context) => Icon( //? gesturedocore pour faire apparait l'adresse dans la barre de recherche, ou afficher détail de l'adresse ?
        FontAwesomeIcons.locationPin,
        size: 40,
        color: Colors.orange,
       )
      
      );

    inspect(selectedDestinationMarker);
  }
}
