import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nancy_stationnement/models/parking.dart';
import 'package:nancy_stationnement/utils/hex_color.dart';
import 'package:nancy_stationnement/services/gny_parking.dart';

class MinParkingCard extends StatelessWidget {
  const MinParkingCard({
    Key? key,
    // required this.gny,
  }) : super(key: key);

  // final GnyParking Function(BuildContext context, {bool listen}) gny;

      // Providers
  final gny = Provider.of<GnyParking>;
  // double cardHeight = 54;

  @override
  Widget build(BuildContext context) {
  Parking parking = gny(context, listen: true).selectedParking!;
    return SizedBox(
        height: 54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Nom de du Parking
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.squareParking,
                    size: 24,
                    color: Colors.blue,
                  ), 
                  Text(
                    "${parking.name}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis
                    ),),
                  ],
              ),
            ),
            // Affichage place PMR
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.wheelchair,
                    size: 18
                  ), 
                  parking.disabled != null ? 
                    Text("${parking.disabled}") : 
                    Text("0") 
                  ],
              ),
            ),
            // Affichage borne de recharge electrique
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.chargingStation,
                    size: 18
                  ), 
                  parking.charging != null ? 
                    Text("${parking.charging}") : 
                    Text("0") 
                  ],
              ),
            ),
            // Affichage Disponibilité
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(""), 
                  parking.available != "null" ? 
                  Text(
                    "${parking.available} places",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      //! Prévoir un cas nullable pour ne pas être bloquant
                      color: HexColor(parking.colorHexa!),
                    ),) :
                    Text(""),
                  ],
              ),
            )
          ],
        ),
      );
  }
}