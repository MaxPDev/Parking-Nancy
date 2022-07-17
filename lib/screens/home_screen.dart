import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import 'package:nancy_stationnement/widgets/main_bottom_app_bar.dart';
import 'package:nancy_stationnement/widgets/parking_popup.dart';
import 'package:nancy_stationnement/widgets/min_parking_card.dart';
import 'package:nancy_stationnement/widgets/parking_card.dart';
import 'package:nancy_stationnement/widgets/top_app_bar.dart';
import 'package:nancy_stationnement/widgets/list_address.dart';

import 'package:nancy_stationnement/services/gny_parking.dart';
import 'package:nancy_stationnement/services/ban_service.dart';

import 'package:nancy_stationnement/utils/hex_color.dart';

///
/// HomeScreen gère l'affichage de la map, écran principal de l'application.
///

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Fonction controllant move, rotate et fitBound de la carte de flutter_map
  // et gére ses propriétés en cours
  final MapController _mapController = MapController();

  // Providers
  final gny = Provider.of<GnyParking>;
  final ban = Provider.of<BanService>;

  List<Marker> _markers = [];
  bool isParkCardSelected = false;
  bool isAddressFieldEditing = false;

  final snackBarPopup = SnackBar(
    content: Text("Disponibilités et marqueurs mis à jour (dev mode)"),
    backgroundColor: Colors.green,
    elevation: 5,
  );

  // Initie les Parkings et leur marqueurs.
  _initParkingMarkers() {
    gny(context, listen: false)
        .initParkingAndGenerateMarkers()
        .then((value) => {
              setState(() {
                _markers =
                    // GnyParking().getParkingsMarkers();
                    gny(context, listen: false).getParkingsMarkers();
              }),
            });
  }


  // Lance la mise à jour de la disponibilité des parkings
  _updatePopupParkings() {
    setState(() {
      print("updatePopuParking");
      _markers = gny(context, listen: false).getParkingsMarkers();

      ScaffoldMessenger.of(context).showSnackBar(snackBarPopup);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Charge l'initialisation des marqueur de Parkings au permiers chargement
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _initParkingMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {

    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: Icon(Icons.refresh),
      // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      // BottomBar
      //TODO: Doit être une search bar, ou celle-ci doit être en dessous.
      //TODO: Faire une fonction deselectParking si utilisable ailleurs //! Fait réduire la Parking Card lors d'une selection d'une icon : not wanted
      // appBar: TopAppBar(onExpansionComplete: () {isParkCardSelected = false;}), 
      appBar: TopAppBar(
        onEdition: () {setState(() {
          isAddressFieldEditing = true;
        });}, 
        onClose: () {setState(() {
          isAddressFieldEditing = false;
        });},
      ), 

      //? Container ?
      body: Column(
        children: [

          // Affiche la liste de recherche d'adresse en fonction de l'action écoutée dans TopAppBar
          isAddressFieldEditing ? Expanded(
            flex: 1,
            child: ListAddress(),
          ) : Container(),
          Expanded(
            flex: 2,
            child: FlutterMap(
              mapController: _mapController,

              // - `center`- Mention the center of the map, it will be the center when the map starts.
              // - `bounds`- It can take a list of geo-coordinates and show them all when the map starts. If both bounds & center are provided, then bounds will take preference.
              // - `zoom`- It is used to mention the initial zoom.
              // - `swPanBoundary`/`nePanBoundary`- These are two geocoordinate points, which can be used to have interactivity constraints.
              // -  Callbacks such as `onTap`/`onLongPress`/`onPositionChanged` can also be used.
              options: MapOptions(
                //TODO: make and use global var/settings
                center: LatLng(48.6907359, 6.1825126),
                // bounds: LatLngBounds(LatLng(48.6292781, 6.0974121), LatLng(48.7589048, 6.3322449)), //# affiche la zone en délimitant des coins
                zoom: 14.0,
                // Empêche la rotation
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                plugins: [
                  MarkerClusterPlugin(),
                ],
                // //TODO: Make hide popup when tap map work
                // onTap: (_, __) => _popupController.hidePopupsOnlyFor(_markers)
              ),
              layers: [
                TileLayerOptions(
                  minZoom: 1, //? Global?
                  maxZoom: 18, //? Global?
                  backgroundColor: Colors.black,
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerClusterLayerOptions(
                    maxClusterRadius: 120,
                    disableClusteringAtZoom: 12,
                    size: const Size(50, 50),
                    fitBoundsOptions:
                        const FitBoundsOptions(padding: EdgeInsets.all(50)),
                    markers: _markers.toList(),
                    polygonOptions: const PolygonOptions(
                        borderColor: Colors.blueAccent,
                        color: Colors.black12,
                        borderStrokeWidth: 3),
                    popupOptions: PopupOptions(
                        popupSnap: PopupSnap.markerTop,
                        //todo: rajouter des conditions comme dans proto en fonction du service selectionné
                        popupController:
                            PopupController(initiallySelectedMarkers: _markers),
                        popupBuilder: (_, marker) {
                          return ParkingPopup(
                              markers: _markers, marker: marker);
                        }),
                    builder: (context, markers) {
                      // Affichage du Widget du Cluster
                      return Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 69, 66, 241),
                            shape: BoxShape.circle),
                        child: Text('${markers.length}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 233, 228, 228))),
                      );
                    })
              ],
            ),
          ),
          Expanded(
            flex: isParkCardSelected ? 3 : 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedSize(
                    duration: Duration(milliseconds: 400),
                    // reverseDuration: Duration(milliseconds: 0),
                    curve: Curves.decelerate,
                    child: Container(
                      color: Color(0xFFE5E5E5),
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      child: gny(context, listen: true).selectedParking != null
                          ? GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onPanUpdate: (details) {
                                if (details.delta.dy < 1) {
                                  print("dragup");
                                  if (!isParkCardSelected) {
                                    setState(() {
                                      isParkCardSelected = true;
                                    });
                                  }
                                } else {
                                  print("drag down");
                                  if (isParkCardSelected) {
                                    setState(() {
                                      isParkCardSelected = false;
                                    });
                                  }
                                }
                              },
                              // onTap: () {
                              //   setState(() {
                              //     isParkCardSelected =
                              //         isParkCardSelected == false ? true : false;
                              //   });
                              // },
                              child: isParkCardSelected
                                  ? ParkingCard()
                                  // ? isPortrait ? ParkingCard() : Text("from home")
                                  : MinParkingCard()) //todo Gesture doctor : miniCard, onTruc : Card (column->row->column)
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),

      // Text("${gny(context, listen: true).selectedParking!.name} :
      // PMR: ${gny(context, listen: true).selectedParking!.disabled},
      // Charging: ${gny(context, listen: true).selectedParking!.charging},
      // dispo: ${gny(context, listen: true).selectedParking!.available}")

      ///
      /// Bar de selection des icones sur la map
      ///
      ///
      // TODO: This must be a Widget
      //? Better Icon ? Global ?
      //! attention, appellé une méthode avec (),n'est pas comme la passer en paramètre
      bottomNavigationBar: MainBottomAppBar(onUpdateTap: _updatePopupParkings),
    );
  }
}


