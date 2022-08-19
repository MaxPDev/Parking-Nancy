import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalText extends ChangeNotifier {

  // Top App Bar
  final String appTitle = "Parking Nancy";
  final String hintText = "Destination...";

  // Side Bar
  final String parkingUpdate = "Mettre à jour les informations des parkings";
  final String parkingUpdateDescr = "Met à jour les nombres de place pour personne à mobilité réduite, les places avec borne de recharge electrique, les tarifs et autres informations. \nUne pression sur le bouton P rafraichit seulement le nombre de places restantes dans les parkings.";

  final String aboutTitle = "À propos";
  final String aboutDescr = "Mentions légales\nLibrairies Open Source\nVersion";
  // final String about1 = "Mentions légales";
  // final String about2 = "Librairies Open Source";
  // final String about3 = "Version";
  // final String
  // final String
  // final String
  // final String
  // final String
  // final String


  GlobalText() {
    if (kDebugMode) {
      print("Global Text constructor");
    }
  }

  void removeListener(VoidCallback listener) {
  // TODO: implement removeListener
  super.removeListener(listener);
  print("removeListener here");
  }

}