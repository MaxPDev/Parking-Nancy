import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nancy_stationnement/utils/hex_color.dart';
import 'package:nancy_stationnement/services/gny_parking.dart';
import 'package:nancy_stationnement/models/parking.dart';

class ParkingCard extends StatelessWidget {
  const ParkingCard({
    Key? key,
  }) : super(key: key);

  final gny = Provider.of<GnyParking>;

  //TODO: Peut être changer les adresse de mgn à OSM dans la récupération, ou l'inverse ! Bien décider

  //? faire évoluer par charging/pmr/max si besoin d'autres conditions :
  //? discerner null et 0.
  static String dataToPrint(data) {
    if((data == null) || (data == "null")) {
      return "-";
    }
    return data;
  }

  static String priceToPrint(price) {
    if((price == null) || (price == "null") || (price == "-")) {
      return "-";
    }
    if(price == "free") {
      return "Gratuit";
    }
    return "$price €";
  }

  static String typeToPrint(type) {
    if((type == null) || (type == "null")) {
      return "_";
    }
    if(type == "underground") {
      return "souterrain";
    }
    if(type == "multi-storey") {
      return "à étages";
    }
    if(type == "surface") {
      return "au sol";
    }
    return type;
  }

  static String operatorToPrint(operator) {
    if(operator == null || operator == "null") {
      return "-";
    }
    return operator;
  }

  //? Mettre les conditions sur les colonnes plutôt que 0 ? Dans certains cas ?
  //? Voir en fonction de la réalité...

  @override
  Widget build(BuildContext context) {
    Parking parking = gny(context, listen: true).selectedParking!;
    inspect(parking);
    late Uri _url;
    if(parking.website != null) {
      _url = Uri.parse(parking.website!);
    }

    return SizedBox(
      height: 375,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Nom du Parking et sa disponbilité
          Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
            Column(
              children: [
                // Nom du parking
                Text("${parking.name}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                // Disponibilité si info disponible
                parking.available != "null"
                    ? Text(
                        "${parking.available} places",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          //! Prévoir un cas nullable pour ne pas être bloquant
                          color: HexColor(parking.colorHexa!),
                        ),
                      )
                    : Text(""),
              ],
            )
          ]),
          // Capacité Max, PMR et Bornes de recharge électrique
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Capacité
              Expanded(
                flex: 2,
                child: Column(
                  children: [Text("Capacité : ")],
                ),
              ),
              // Capacité max
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text("Max."),
                    Text(dataToPrint(parking.capacity))
                  ],
                ),
              ),
              // PMR
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Icon(FontAwesomeIcons.wheelchair, size: 18),
                    Text(dataToPrint(parking.disabled))
                  ],
                ),
              ),
              // Bornes de recharge
              Expanded(
                flex: 3,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.chargingStation, size: 18),
                    Text(dataToPrint(parking.charging))
                  ],
                ),
              ),
            ],
          ),
          // Tarifs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tarifs
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text("Tarif : ")
                  ],
                ),
              ),
              // Tarif 30 min
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text("30 min"),
                    Text(priceToPrint(parking.prices!['30']))
                  ],
                ),
              ),

              // Tarif 60 min
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text("1h"),
                    Text(priceToPrint(parking.prices!['60']))
                  ],
                ),
              ),

              // Tarif 120 min
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text("2h"),
                    Text(priceToPrint(parking.prices!['120']))
                  ],
                ),
              ),

              // Tarif 240 min
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text("4h"),
                    Text(priceToPrint(parking.prices!['240']))
                  ],
                ),
              ),

            ],
          ),
          // Type et Haute du parking
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              // Type Hauteur
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text("Hauteur max : ${parking.maxHeight}")
                  ],
                ),
              ),

              // Type parking
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text("Type : " + typeToPrint(parking.type))
                  ],
                ),
              ),
            ],
          ),

          // Adresse
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Adresse
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.house,
                      size: 18
                    ),
                    // OSM
                    // Text(dataToPrint(parking.addressNumber)),
                    // Text(dataToPrint(parking.addressStreet)),
                    // MGN
                    Text(
                      dataToPrint(parking.address),
                      style: TextStyle(
                        overflow: TextOverflow.clip
                      ),)
                  ],
                ),
              ),
            ],
          ),
          // Téléphone et Site Web
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              // Téléphone
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.phone,
                      size: 18
                    ),
                    Text(dataToPrint(parking.phone))
                  ],
                ),
              ),
              
              // Site Web
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.globe,
                      size: 18
                    ),
                    parking.website != null ? InkWell(
                      child: Text('Site Web', style: TextStyle(color: Colors.blue),),
                      onTap: () => launchUrl(_url),
                    ) :
                    Text("-")
                  ],
                ),
              ),


            ],
          ),

          // Propriétaire
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              // Type Hauteur
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text("Propriétaire: " + operatorToPrint(parking.operator))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
