import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';

import 'dart:convert'; // to user jsonDecode
import 'dart:developer';

import 'package:nancy_stationnement/models/parking.dart';
import 'package:nancy_stationnement/database/database_handler.dart';
import 'package:nancy_stationnement/services/check_connection.dart';
import 'package:nancy_stationnement/utils/hex_color.dart';
import 'package:nancy_stationnement/utils/marker_with_value.dart';
import 'package:nancy_stationnement/services_config.dart' as config;

class GnyParking extends ChangeNotifier {
  bool isGnyConnection = false;
  bool isParkingDatabaseEmpty = true;

  static List<Parking> _parkings = [];
  Parking? selectedParking;

  static List<Marker> _markers = [];

  GnyParking() {
    if (kDebugMode) {
      print("GnyParking constructor");
    }
  }

  // SnackBar errorToSnack(String message) {
  //   return SnackBar(
  //     content: Text(message),
  //     backgroundColor: Colors.red,
  //     duration: Duration(seconds: 30),
  //   );
  // }
  
  // Prépare la liste de parking, génère les marqueur
  Future<void> initParkingAndGenerateMarkers() async {
    // Delete database : only for dev test, or implement if fulling database doesn't work
    // await DatabaseHandler.instance.deleteDatabase("parkings.db");
    
    // Initialise les Parking
    await initParking();
    // Génère les marqueurs
    generateParkingMarkers();
  }

    // Supprime la DB pour la remplir à nouveauPrépare la liste de parking, génère les marqueur
  Future<void> reInitParkingAndGenerateMarkers() async {
    //TODO; Try catch, ou mettre dans initParking a else
    // // Supprime la database : pour tester le remplissage.
    // await DatabaseHandler.instance.deleteDatabase('parkings.db');
    await DatabaseHandler.instance.resetParkingsTables();
    // Initialise les Parking
    await initParking();
    // Génère les marqueurs
    generateParkingMarkers();
  }

  // Rempli la liste de Parking depuis la DB Local:
  //  Si pas de parking dans la DB Local :
  //   Récupère les informations depuis g-ny.org et rempli la DB
  //
  Future<void> initParking() async {
    // Vérifie la connection internet vers go.gny.org
    isGnyConnection = await CheckConnection.isGnyConnection();

    // Vérifie dans la base de données si la table des parking est vide (true) ou remplie (false)
    isParkingDatabaseEmpty = await DatabaseHandler.instance.isParkingEmpty();

    // Rempli la base de données si elle est vide, en allant chercher les données
    if (isParkingDatabaseEmpty) {
      if (isGnyConnection) {
        if (kDebugMode) {
          print("fulling parking database");
        }

        Map<String, dynamic> data = await fetchDataParkings();

        data.forEach((key, value) async {
          var id = await DatabaseHandler.instance
              .createParking(Parking.fromAPIJson(data[key]));
        });
      } else {
        //? Générer affichage d'erreur ici ?
        print(
            "Récupération des Parkings impossible, pas de connecion"); //? try catch ?
      }
    } else {
      //? update, ou alors le faire ailleurs ?
      if (kDebugMode) {
        print("database parking already setup");
      }
    }
    // _parkings.clear();
    //? Utile si accessible depuis DatabaseHandler ?
    _parkings = await DatabaseHandler.instance.getAllParking();
    await fetchDynamicDataParkings();

    inspect(_parkings);
  }

  //
  // Récupère les données de parking depuis go.g-ny.org
  //
  Future<Map<String, dynamic>> fetchDataParkings() async {
    try {
      // Récupère les données via l'API
      // var uri = Uri.parse('${uriGny}json');
      var uri = Uri.parse('${config.gnyUri}${config.gnyJson}');
      Response response = await get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);

      return data;
    } catch (e) {
      //todo : remonter les erreurs dans un affichage user
      if (kDebugMode) {
        print('Caught error in GnyParking.fetchDataParking() : $e');
      }
      rethrow;
    }
  }

  // Future parkingsToDatabase() async {
  //   _parkingsFromAPI.forEach((parking) async {
  //     var id = await DatabaseHandler.instance.createParking(parking);
  //     print(id);
  //   });
  // }

  //
  // Récupère les données dynamiques de parking depuis go.g-ny.org
  //
  Future<void> fetchDynamicDataParkings() async {
    try {
      // Récupère les données via l'API
      // var uri = Uri.parse('${uriGny}hot');
      var uri = Uri.parse('${config.gnyUri}${config.gnyHot}');
      Response response = await get(uri);
      Map<String, dynamic> data = jsonDecode(response.body);

      // Met à jour les objets parkings avec les nouvelles données
      for (Parking parking in _parkings) {
        data.forEach((key, value) {
          if (parking.id == key) {
            // parking.capacity = data[key]["capacity"] == null
            //     ? null
            //     : int?.parse(data[key]["capacity"].toString());
            parking.capacity = data[key]["capacity"].toString();
            parking.available = data[key]["mgn:available"].toString();
            parking.isClosed = data[key]["mgn:closed"];
            parking.colorHexa = data[key]["ui:color"];
            parking.colorText = data[key]["ui:color_en"];
          }
        });
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Caught error in GnyParking.fetchDynamicDataParking() : $e');
        // snackBarError = errorToSnack(e.toString());
      }
    }
  }

  //
  // Construit les markers depuis les objets parking
  //
  void generateParkingMarkers() {
    List<Marker> markers = [];
    for (var parking in _parkings) {
      //todo récupérer depuis db
      markers.add(Marker(
          key: const ObjectKey("parking_marker"),
          // objectId: parking.id,
          point: LatLng(parking.coordinates[1],
              parking.coordinates[0]), //? refaire en parking.lat et.long ?
          width: 30,
          height: 30,
          builder: (context) => GestureDetector(
            // onTap: () => //,
            onTap: () {
              print("${parking.name} tapped");
              selectedParking = parking;
              // selectedParking = selectedParking != null ? null : parking;
              inspect(selectedParking);
              notifyListeners();
            },
            // child: Icon(
            //       FontAwesomeIcons.squareParking,
            //       size: 30,
            //       color: parking.isClosed != null ?
            //         !parking.isClosed! ? Colors.blue : Colors.red
            //         : Colors.blue,
            //     ),
            child: parking.zone == "Parking Relais" ?
            Image.asset(
              "assets/images/icone_parking_relais.png",
              // color: parking.isClosed != null ?
              //   !parking.isClosed! ? Colors.blue : Colors.red
              //   : Colors.blue,
            )
            : Image.asset(
              "assets/images/icone_parking.png",
              color: parking.isClosed != null ?
                !parking.isClosed! ? Colors.blue : Colors.red
                : Colors.blue,
            ),
          )));
    }
    _markers.clear(); //? useless ?
    _markers = markers;
  }

  // Renvoie les la liste des markers
  List<Marker> getParkingsMarkers() {
    return _markers;
  }

   // Récupère Parking depuis les coordonnées
  //! Contournement? FAIRE AVEC LES OBJECTKEY
  static Parking getParkingFromCoordinates(LatLng point) {
    return _parkings.firstWhere((parking) =>
        parking.coordinates[1] == point.latitude &&
        parking.coordinates[0] == point.longitude);
    // notifyListeners();
    // return parking;
  }

  /**
   * Récupère et rénvoie la propriété available depuis les coordonnées
   */
  //! Contournement FAIRE AVEC LES OBJECTKEY
  //TODO: optimisiation : return directement, + . availabe
  static String? getAvailableFromCoordinates(LatLng point) {
    Parking parkingPopup = _parkings.firstWhere((parking) =>
        parking.coordinates[1] == point.latitude &&
        parking.coordinates[0] == point.longitude);
    // notifyListeners();
    return parkingPopup.available;
  }

  /**
   * Récupère et rénvoie la propriété uiColor_en depuis les coordonnées
   */
  //! If parkings is closed color !
  //! Contournement FAIRE AVEC LES OBJECTKEY
  static Color? getColorFromCoordinates(LatLng point) {
    Parking parkingPopup = _parkings.firstWhere((parking) =>
        parking.coordinates[1] == point.latitude &&
        parking.coordinates[0] == point.longitude);

    // notifyListeners();
    // //! Prevoir le cas null pour ne pas être bloquant
    // return HexColor(parkingPopup.colorHexa!);

    switch (parkingPopup.colorText) {
      case "blue":
        {
          return Colors.blue;
        }

      case "orange":
        {
          return Colors.orange;
        }

      case "green":
        {
          return Colors.green;
        }

      case "red":
        {
          return Colors.red;
        }

      default:
        {
          return Colors.black;
        }
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
    super.removeListener(listener);
    print("removeListener here");
  }
}
