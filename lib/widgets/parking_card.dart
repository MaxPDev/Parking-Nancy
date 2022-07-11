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

  @override
  Widget build(BuildContext context) {
    Parking parking = gny(context, listen: true).selectedParking!;
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
                Text(
                  "${parking.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                ),
                // Disponibilité si info disponible
                parking.available != "null" ? 
                  Text(
                    "${parking.available} places",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      //! Prévoir un cas nullable pour ne pas être bloquant
                      color: HexColor(parking.colorHexa!),
                    ),) :
                    Text(""),
              ],
            )
          ]),
          GestureDetector(
              onTap: () => print("yes"),
              child: Row(children: [Text("3"), Text("4")])),
        ],
      ),
    );
  }
}
