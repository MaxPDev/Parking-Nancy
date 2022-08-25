import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalText extends ChangeNotifier {

  ///*Homescreen
  
  //* Snackbars
  final String parkingsAvailabiltyUpdated = "Disponibilités des parkings mis à jour";
  final String bikeStationsAvailabiltyUpdated = "Disponibilités des stations de vélo mis à jour";
  final String parkingsDataUpdated = "Données des parkings mis à jour";
  final String connexionError = "Récupération des données impossible. Vérifiez votre connexion internet";
  
  //* Message d'accueil et de sortie d'application
  static String welcomeTitle = "Parking Nancy";
  static String welcomeText = "Cette application affiche en temps réel de la disponibilité des parkings de Nancy. \n\nATTENTION : Ne pas utiliser le téléphone en conduisant !";
  static String welcomeConfirm = "Ok";

  static String quitTitle = "Quitter Parking Nancy";
  static String quitMessage = "Voulez-vous quitter l'application ?";
  static String quitNo = "Non";
  static String quitYes = "Oui";

  //==========================================

  //* Top App Bar
  final String appTitle = "Parking Nancy";
  final String hintText = "Destination...";

  //==========================================

  //* Side Bar
  final String parkingUpdate = "Mettre à jour les informations des parkings";
  final String parkingUpdateDescr = "Met à jour les nombres de place pour personne à mobilité réduite, les places avec borne de recharge electrique, les tarifs et autres informations. \nUne pression sur le bouton P rafraichit seulement le nombre de places restantes dans les parkings.";

  final String aboutTitle = "À propos";
  final String aboutDescr = "Mentions légales\nLibrairies Open Source\nVersion";

  //==========================================

  //* Min Parking Card & Parking Card
  final String places = "places";
  // final String parkAndRide = "Parking Relais";

  //* To Route
  final String go = "Y aller";

  //* Parking Card
  final String capacity = "Capacity :";
  final String max = "Max.";
  final String prices = "Tarifs :";
  //? 30min, 1h, 2h, 4h ?
  final String maxHeight = "Hauteur max :";
  final String type = " Type :";
  final String owner = "Propriétaire :";
  final String webSite = "Site Web";
  final String parkingClosed = "Parking fermé";

  //==========================================

  //* Bikestation popup
  final String availableBikes = "vélos disponibles";
  final String availableStands = "emplacements disponibles";
  final String availableCreditCardPayment = "Paiement par carte bancaire disponible";

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