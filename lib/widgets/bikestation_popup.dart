import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nancy_stationnement/models/station.dart';
import 'package:nancy_stationnement/services/jcdecaux_velostan.dart';
import 'package:nancy_stationnement/text/app_text.dart' as text;
import 'package:provider/provider.dart';

class BikestationPopup extends StatefulWidget {
  const BikestationPopup({
    Key? key,
    required Marker marker,
    // required bool isBikeMinPopupVisible
  })  : _marker = marker,
        // _isBikeMinPopupVisible = isBikeMinPopupVisible,
        super(key: key);

  final Marker _marker;
  // final bool _isBikeMinPopupVisible;

  @override
  State<BikestationPopup> createState() => _BikestationPopupState();
}

class _BikestationPopupState extends State<BikestationPopup> {
  final bikeStations = Provider.of<JcdecauxVelostan>;

  //? Mettre SizedBox partout pour continer Text avec maxLines au cas où ?

  @override
  Widget build(BuildContext context) {
    Station bikeStation = bikeStations(context, listen: false)
        .getStationFromCoordinates(widget._marker.point);

    Future<void> _initStationDataPopup() async {
      await bikeStations(context, listen: false)
          .getStationWithDynamicDataFromStationId(bikeStation.id)
          .then(
        (value) {
          bikeStation = bikeStations(context, listen: false).selectedStation;
        },
      );
    }

    void refresh() {
      setState(() {
        
      });
    }

    return SizedBox(
      width: 300,
      height: 220,
      child: FutureBuilder(
        future: _initStationDataPopup(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: Alignment.bottomCenter,
                child: const SizedBox(
                  width: 54,
                  height: 10,
                  child: LinearProgressIndicator(
                    backgroundColor: Color.fromRGBO(210, 255, 197, 0.9),
                    color: Color.fromARGB(255, 9, 148, 81),
                  )
                  ),
              );
            }
            if (snapshot.hasError) {
              return Text('Main Error: ${snapshot.error}');
              // If got data
            }
            // In this case, future methode is void, so homeScreen
            // = hasData()
            return StationPopup(bikeStation: bikeStation, update: refresh,);
          },
      ),
    );
    // return StationPopup(bikeStation: bikeStation);
  }
}

class StationPopup extends StatelessWidget {
  const StationPopup({
    Key? key,
    required this.bikeStation,
    required this.update
  }) : super(key: key);

  final Station bikeStation;
  final Function update;



  // Traite le texte de titre pour enlever le numéro de station et la mention "CB"
  String bikeStationNameToShorter(name) {
    if (name.indexOf("(CB") == -1) {
      return name.substring(8).trim();
    }
    return name.substring(
      8, 
      name.indexOf("(CB)")
    );
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 220,
      width: 300,
      child: Container(
        // constraints: BoxConstraints(maxWidth: 300, maxHeight: 200),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        // width: 400,
        // height: 200,
        decoration: BoxDecoration(
          color: bikeStation.status == "OPEN" ?
          const Color.fromRGBO(210, 255, 197, 0.9) :
          const Color.fromARGB(255, 241, 154, 132),
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text.velostan,
                  style: Theme.of(context).textTheme.bodyText2
                  // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),

            const SizedBox(
              height: 3,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bikeStationNameToShorter(bikeStation.name),
                  style: Theme.of(context).textTheme.headline4
                  // style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),

            const SizedBox(
              height: 10,
            ),
            
            Row(
              children: [
                const Icon(FontAwesomeIcons.bicycle, color: Colors.black, size: 16),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "${bikeStation.bikes} ",
                  style: const TextStyle(
                    // fontSize: 15, 
                    fontWeight: FontWeight.bold),
                ),
                const Text(
                  text.availableBikes,
                  style: TextStyle(
                    // fontSize: 14, 
                    fontWeight: FontWeight.normal),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(FontAwesomeIcons.checkToSlot,
                    color: Colors.black, size: 16),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "${bikeStation.stands} ",
                  style: const TextStyle(
                    // fontSize: 15, 
                    fontWeight: FontWeight.bold),
                ),
                const Text(
                  text.availableStands,
                  style: TextStyle(
                    // fontSize: 14, 
                    fontWeight: FontWeight.normal),
                )
              ],
            ),
            bikeStation.banking
                ? Row(
                    children: const [
                      Icon(FontAwesomeIcons.creditCard,
                          color: Colors.black, size: 16),
                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 244,
                        child: Text(
                          text.availableCreditCardPayment,
                          style: TextStyle(
                              // fontSize: 14, 
                              fontWeight: FontWeight.normal),
                              maxLines: 2,
                        ),
                      )
                    ],
                  )
                : Container(),
            Row(
              children: [
                const Icon(FontAwesomeIcons.house,
                    color: Colors.black, size: 16),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 240,
                  child: Text(
                    bikeStation.address,
                    style: const TextStyle(
                      // fontSize: 14, 
                      fontWeight: FontWeight.normal),
                    maxLines: 3,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (() {
                    update();
                  }),
                  child: const Icon(Icons.update,
                      color: Colors.black, size: 24),
                ),

              ],
            ),
            bikeStation.status == "CLOSE" ?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  " - STATION FERMÉE - ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),

              ],
            ) :
            Container()
          ],
        ),
      ),
    );
  }
}
