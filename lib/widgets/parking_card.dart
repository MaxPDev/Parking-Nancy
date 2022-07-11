import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nancy_stationnement/utils/hex_color.dart';
import 'package:nancy_stationnement/services/gny_parking.dart';
import 'package:nancy_stationnement/models/parking.dart';

class ParkingCard extends StatelessWidget {
  const ParkingCard({
    Key? key,
  }) : super(key: key);

  final gny = Provider.of<GnyParking>;

  //? Mettre les conditions sur les colonnes plutôt que 0 ? Dans certains cas ?
  //? Voir en fonction de la réalité...

  @override
  Widget build(BuildContext context) {
    Parking parking = gny(context, listen: true).selectedParking!;
    inspect(parking);
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
              Column(
                children: [Text("Capacité :")],
              ),
              // Capacité max
              Column(
                children: [
                  Text("Max."),
                  parking.capacity != "null"
                      ? Text("${parking.capacity}")
                      : Text("_")
                ],
              ),
              // PMR
              Column(
                children: [
                  Icon(FontAwesomeIcons.wheelchair, size: 18),
                  parking.disabled != null
                      ? Text("${parking.disabled}")
                      : Text("0")
                ],
              ),
              // Bornes de recharge
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.chargingStation, size: 18),
                  parking.charging != null
                      ? Text("${parking.charging}")
                      : Text("0")
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
