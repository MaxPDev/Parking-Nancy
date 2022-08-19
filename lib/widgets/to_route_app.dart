import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nancy_stationnement/models/parking.dart';

class ToRouteApp extends StatelessWidget {
  const ToRouteApp({
    Key? key,
    required Parking parking,
    // required double? normalTextCardFontSize,
  }) : _parking = parking, 
      //  _normalTextCardFontSize = normalTextCardFontSize, 
       super(key: key);

  final Parking _parking;
  // final double? _normalTextCardFontSize;

  openMapsSheet(context, double lat, double long, String name) async {
    try {
      final coords = Coords(lat, long);
      final title = name;
      final availableMaps = await MapLauncher.installedMaps;
      if (kDebugMode) {
        print(availableMaps);
      }

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showMarker(
                        coords: coords,
                        title: title,
                      ),
                      title: Text(map.mapName),
                      leading: SvgPicture.asset(
                        map.icon,
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openMapsSheet(
          context,
          _parking.coordinates[1],
          _parking.coordinates[0],
          _parking.name == null ? "parking" : _parking.name!),
      child: Container(
        // constraints: BoxConstraints(minWidth: 50),
        padding: EdgeInsets.fromLTRB(21, 10, 21, 7),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 221, 200, 7),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(FontAwesomeIcons.route, size: 21),
            SizedBox(
              width: 10,
            ),
            Text(
              "Y aller",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // fontSize: _normalTextCardFontSize
                ),
            ),
          ],
        ),
      ),
    );
  }
}
