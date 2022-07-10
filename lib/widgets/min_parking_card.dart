import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                    "${gny(context, listen: true).selectedParking!.name}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis
                    ),),
                  ],
              ),
            ),
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
                  gny(context, listen: true).selectedParking!.disabled != null ? 
                    Text("${gny(context, listen: true).selectedParking!.disabled}") : 
                    Text("0") 
                  ],
              ),
            ),
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
                  gny(context, listen: true).selectedParking!.charging != null ? 
                    Text("${gny(context, listen: true).selectedParking!.charging}") : 
                    Text("0") 
                  ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(""), 
                  gny(context, listen: true).selectedParking!.charging != null ? 
                  Text(
                    "${gny(context, listen: true).selectedParking!.available} places",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      //! Prévoir un cas nullable pour ne pas être bloquant
                      color: HexColor(gny(context, listen: true).selectedParking!.colorHexa!),
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