import 'package:flutter/material.dart';
import 'package:nancy_stationnement/widgets/to_route_app.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nancy_stationnement/models/parking.dart';
import 'package:nancy_stationnement/utils/hex_color.dart';
import 'package:nancy_stationnement/services/gny_parking.dart';
import 'package:nancy_stationnement/widgets/items.dart';

class MinParkingCard extends StatelessWidget {
  MinParkingCard({
    Key? key,
    // required this.gny,
  }) : super(key: key);

  // final GnyParking Function(BuildContext context, {bool listen}) gny;

      // Providers
  final gny = Provider.of<GnyParking>;
  // double cardHeight = 54;

  //? faire évoluer par charging/pmr/max si besoin d'autres conditions :
  //? discerner null et 0.
  static String dataToPrint(data) {
    if((data == null) || (data == "null")) {
      return "-";
    }
    return data;
  }

  double? sizedBoxHeighMiddle = 7;
  double? sizedBoxHeighBottom = 9;

  //! If parking is closed !

  @override
  Widget build(BuildContext context) {
  Parking parking = gny(context, listen: true).selectedParking!;
  double width = MediaQuery.of(context).size.width;
    return SizedBox(
        // height: 54,
        child: Column(
          children: [
            // Flèche d'agrandissement
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 12,
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 20),
                ),
              ],
            ),
            DividerQuart(width: width),
           parking.zone != null ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  parking.zone != "Parking Relais" ? "${parking.zone}" : "${parking.zone}",
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              ],
            ) : Container(),
            parking.zone != null ? DividerQuart(width: width) : Container(),

            // Affichage si parking fermé
            parking.isClosed != null ?
              parking.isClosed == true ?
                Text(
                  "Parking fermé", 
                  style: TextStyle(
                    color: Colors.red, 
                    fontSize: 15,
                    fontWeight: FontWeight.bold))
                : Container()
            : Container(),

            Row(
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
                      SizedBox(
                        height: sizedBoxHeighMiddle,
                      ),
                      Text(
                        "${parking.name}",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
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
                      SizedBox(
                        height: sizedBoxHeighMiddle,
                      ), 
                      Text(dataToPrint(parking.disabled)) 
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
                      SizedBox(
                        height: sizedBoxHeighMiddle,
                      ), 
                      Text(dataToPrint(parking.charging)) 
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
                      // Text("", style: TextStyle(fontStyle: FontStyle.italic),), 
                      // SizedBox(
                      //   height: sizedBoxHeighMiddle,
                      // ),
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
                ),
              ],
            ),
            DividerQuart(width: width),

            SizedBox(
              width: width/3,
              child: ToRouteApp(
                parking: parking, 
                normalTextCardFontSize: 14)),

            SizedBox(
              height: sizedBoxHeighBottom,
            ),
          ],
        ),
      );
  }
}