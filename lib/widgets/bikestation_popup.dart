import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
// import 'package:latlong2/latlong.dart';

import 'package:nancy_stationnement/models/station.dart';
import 'package:nancy_stationnement/services/jcdecaux_velostan.dart';
import 'package:provider/provider.dart';

class BikestationPopup extends StatefulWidget {
  const BikestationPopup({
    Key? key,
    required Marker marker,
    required bool isBikeMinPopupVisible
  }) : _marker = marker,
      _isBikeMinPopupVisible = isBikeMinPopupVisible,
      super(key: key);

  final Marker _marker;
  final bool _isBikeMinPopupVisible;

  @override
  State<BikestationPopup> createState() => _BikestationPopupState();
}

class _BikestationPopupState extends State<BikestationPopup> {
  final bikeStations = Provider.of<JcdecauxVelostan>;

  bool bigPopup = false;

  @override
  Widget build(BuildContext context) {
    Station bikeStation = 
      new Station(id: 0, name: "", address: "", long: 0, lat: 0, status: "", banking: false);

    Future<void> _initStationDataPopup() async {
      await bikeStations(context, listen: false).
        getStationWithDynamicDataFromCoordinates(widget._marker.point).
        then((value) {
          bikeStation = bikeStations(context, listen: false).selectedStation;
        },);
    }

    // bikeStations(context, listen: false).getStationWithDynamicDataFromCoordinates(_marker.point).then((value) {
    //   bikeStation = bikeStations(context, listen: false).selectedStation;
    // });

    // futurebuilder

    // inspect(bikeStation);

    return bigPopup ?
      StationPopupBig(bikeStation: bikeStation) :

      widget._isBikeMinPopupVisible ? StationPopup(
      bikeStation: bikeStations(context, listen: false)
                    .getStationFromCoordinates(widget._marker.point))
                    :
                    InkWell(
                      onTap: () {
                        bigPopup ? bigPopup = false : bigPopup = true;
                      },
                    );


    // return bikeStation.id < 1 ? 
    // GestureDetector(
    //   onTap: () {
    //     setState(() {
    //       bigPopup ? bigPopup = false : bigPopup = true;
    //     });
    //   },
    //   child: FutureBuilder(
    //     future : _initStationDataPopup(),
    //     builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return CircularProgressIndicator();
    //       }
    //       if (snapshot.hasError) {
    //         return Text('Main Error: ${snapshot.error}');
    //       }

    //       return bigPopup ? StationPopupBig(bikeStation: bikeStation): 
    //       StationPopup(bikeStation: bikeStation);
    //     }
    //   )
    // )
    // :
    // StationPopup(bikeStation: bikeStation);

  }
}

class StationPopup extends StatelessWidget {
  const StationPopup({
    Key? key,
    required this.bikeStation,
  }) : super(key: key);

  final Station bikeStation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 90,
      // color: Color.fromRGBO(216, 212, 212, 0.54),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(9, 148, 81, 0.70),
              shape: BoxShape.rectangle
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${bikeStation.bikes}", style: TextStyle(fontSize: 14, color: Colors.white70)),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  FontAwesomeIcons.bicycle,
                  color: Colors.white70,
                  size: 12
                ),
          
                SizedBox(
                  width: 7,
                ),
              
                Text("${bikeStation.stands}", style: TextStyle(fontSize: 14, color: Colors.white70)),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  FontAwesomeIcons.checkToSlot,
                  color: Colors.white70,
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





class StationPopupBig extends StatelessWidget {
  const StationPopupBig({
    Key? key,
    required this.bikeStation,
  }) : super(key: key);

  final Station bikeStation;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Color.fromARGB(255, 161, 219, 176),
      title: Text(
        "${bikeStation.name}",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        SimpleDialogOption(
          child: Text(
            "Velo disponible : ${bikeStation.bikes}",
            style: TextStyle(color: Colors.black),
          ),
        ),
        SimpleDialogOption(
          child: Text("Emplacements libre : ${bikeStation.stands}"),
        )
      ],
    );
  }
}
