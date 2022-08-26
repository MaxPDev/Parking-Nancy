import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:latlong2/latlong.dart';
import 'package:nancy_stationnement/services/global_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import 'package:nancy_stationnement/widgets/main_bottom_app_bar.dart';
import 'package:nancy_stationnement/widgets/parking_popup.dart';
import 'package:nancy_stationnement/widgets/bikestation_popup.dart';
import 'package:nancy_stationnement/widgets/min_parking_card.dart';
import 'package:nancy_stationnement/widgets/parking_card.dart';
import 'package:nancy_stationnement/widgets/top_app_bar.dart';
import 'package:nancy_stationnement/widgets/list_address.dart';
import 'package:nancy_stationnement/widgets/side_bar.dart';

import 'package:nancy_stationnement/services/store.dart';
import 'package:nancy_stationnement/services/gny_parking.dart';
import 'package:nancy_stationnement/services/ban_service.dart';
import 'package:nancy_stationnement/services/jcdecaux_velostan.dart';
import 'package:nancy_stationnement/services/global_text.dart';

// import 'package:nancy_stationnement/utils/marker_with_value.dart';
// import 'package:nancy_stationnement/utils/marker_with_value_cluster_layer_options.dart';
import 'package:nancy_stationnement/utils/hex_color.dart';

///
/// HomeScreen gère l'affichage de la map, écran principal de l'applicati=on.
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
  //TODO: dans la var, mettre jusque (context, listen: false), en vérifiant si des true sont utilisés
  final store = Provider.of<Store>;
  final gny = Provider.of<GnyParking>;
  final ban = Provider.of<BanService>;
  final bikeStations = Provider.of<JcdecauxVelostan>;
  final text = Provider.of<GlobalText>;
  List<Marker> _markers = [];
  bool isParkCardSelected = false;
  bool isAddressFieldEditing = false;
  bool isBikeMinPopupVisible = false;
  Map areParkingTitleVisible = {'three': false, 'six': false, 'all': false};

  final snackBarPopupParking = SnackBar(
    content: Text(
      GlobalText().parkingsAvailabiltyUpdated,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500
      )
    ),
    backgroundColor: Colors.blue,
    duration: Duration(seconds: 3),
    elevation: 5,
  );

  final snackBarPopupBikeStation = SnackBar(
    content: Text(
      GlobalText().bikeStationsAvailabiltyUpdated,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500
      )
    ),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 3),
    elevation: 5,
  );

  final snackBarParking = SnackBar(
    content: Text(
      GlobalText().parkingsDataUpdated,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500
      )
    ),
    backgroundColor: Colors.blue,
    elevation: 5,
  );

  final snackBarConnexionError = SnackBar(
    duration: Duration(seconds: 7),
    content: Text(
      GlobalText().connexionError,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500
      )
    ),
    backgroundColor: Colors.red,
    elevation: 5,
  );

  /// Parkings

  // Initie les Parkings et leur marqueurs.
  _initParkingMarkers() {
    gny(context, listen: false)
        .initParkingAndGenerateMarkers()
        .then((value) => {
              setState(() {
                if (gny(context, listen: false).isGnyConnection == false) {
                  FlutterNativeSplash.remove();
                  ScaffoldMessenger.of(context).showSnackBar(snackBarConnexionError);
                } else {
                _markers =
                    gny(context, listen: false).getParkingsMarkers();
                    FlutterNativeSplash.remove();
                }
              }),
              //! Risqué si échec
            });
  }

  // Lance la mise à jour des données de parkings
  _updateParking() {
      gny(context, listen: false)
        .reInitParkingAndGenerateMarkers()
        .then((value) => {
              setState(() {
                _markers = gny(context, listen: false).getParkingsMarkers();
                if (gny(context, listen: false).isGnyConnection == false) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBarConnexionError);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(snackBarParking);
                  // Bascule sur l'onglet parking
                  store(context, listen: false).userSelection = "parkings";
                }
              }),
            });
  }

  // Lance la mise à jour de la disponibilité des parkings
  _updatePopupParkings() {
    gny(context, listen: false)
      .initParkingAndGenerateMarkers()
      .then((value) => {
        setState(() {
          _markers = gny(context, listen: false).getParkingsMarkers();
          if (gny(context, listen: false).isGnyConnection == false) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarConnexionError);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBarPopupParking);
          }
        }),
      });
  }

  _setParkingsMarkers() {
    _markers = gny(context, listen: false).getParkingsMarkers();
    if (gny(context, listen: false).isGnyConnection == false) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarConnexionError);
    }
  }

  /// Stations de Vélo

  // Initie les stations de vélos.
  _initBikeStations() {
    bikeStations(context, listen: false).initStations()
      .then((value) {
        bikeStations(context, listen: false).generateStationsMarker();
      });
  }

  // Met à jour les données des vélos.
  //? Message d'erreur fonctionne pas ?
  _updateBikeStations() {
    bikeStations(context, listen: false).initStations()
      .then((value) {
        setState(() {
          _markers = bikeStations(context, listen: false).stationMarkers;
          if (gny(context, listen: false).isGnyConnection == false) {
            ScaffoldMessenger.of(context).showSnackBar(snackBarConnexionError);
          } else {
            bikeStations(context, listen: false).stationMarkers.isEmpty ?
              _initBikeStations() : 
              bikeStations(context, listen: false).generateStationsMarker();
            ScaffoldMessenger.of(context).showSnackBar(snackBarPopupBikeStation);
          }
        });
      });
  }

  // Active les marques des stations de vélos
  _setBikeStationsMarkers() {
    _markers = bikeStations(context, listen: false).stationMarkers;
    if (gny(context, listen: false).isGnyConnection == false) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarConnexionError);
    }
  }

  /// Marqueur de localisation / d'adresse

  // Affiche le marqueur de la destination
  _displayDestinationMarker() {
    _markers.forEach((marker) {
      if (marker.key == ObjectKey("address_marker")) {
        _markers.remove(marker);
        print("sould not be there first time");
      }
    });

    setState(() {
      _markers.add(ban(context, listen: false).selectedDestinationMarker);
      _mapController.move(ban(context, listen: false).selectedDestinationMarker.point, 16);
    });

    _markers.forEach((marker) {
      if (marker.key == ObjectKey("address_marker")) {
        print("sould not here once");
      }
    });
  }


  // // Switch de la mini card Parking à la grand card Parking
  // switchParkCardSelected() {
  //   // setState(() {
  //   //   isParkCardSelected ? isParkCardSelected = false : isParkCardSelected = true;
  //   // });
  //   print("test");
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Charge l'initialisation des marqueur de Parkings au permiers chargement
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _initParkingMarkers();
      _initBikeStations();
      _displayWelcomeMessage();
      // areParkingTitleVisible["three"] = false;
      // areParkingTitleVisible["six"] = false;

      // //TODO: Remove Splashscreen. Could be put after initialization rather than here
      // FlutterNativeSplash.remove();
    });

    // AlertDialog(
    //   title: Text("Avertissement"),
    //   content: Text("Ne pas utilisez le téléphone en conduisant (...)"),
    //   actions: [
    //     TextButton(
    //       onPressed: () {
    //         print("test");
    //       },
    //       child: Icon(Icons.close)
    //     )
    //   ]
    // );
  }

    // Message d'accueil et d'avertissement
    Future<bool> _displayWelcomeMessage() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text(GlobalText.welcomeTitle),
            content: new Text(GlobalText.welcomeText),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: new Text(GlobalText.welcomeConfirm),
              ),
            ],
          ),
        )) ??
        false;
    }

    // Demande de confirmation de sortie de l'application
    Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text(GlobalText.quitTitle),
            content: new Text(GlobalText.quitMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(GlobalText.quitNo),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text(GlobalText.quitYes),
              ),
            ],
          ),
        )) ??
        false;
    }



  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    String _selectedMarkers = ""; // useless ??


    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // floatingActionButton: Icon(Icons.refresh),
        // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        // BottomBar
        //TODO: Doit être une search bar, ou celle-ci doit être en dessous.
        //TODO: Faire une fonction deselectParking si utilisable ailleurs //! Fait réduire la Parking Card lors d'une selection d'une icon : not wanted
        // appBar: TopAppBar(onExpansionComplete: () {isParkCardSelected = false;}),
        appBar: TopAppBar(
          onEdition: () {
            if (!isAddressFieldEditing) {
              setState(() {
                isAddressFieldEditing = true;
              });
            }
          },
          onClose: () {
            setState(() {
              isAddressFieldEditing = false;
              _markers.removeWhere((marker) => marker.key == ObjectKey("address_marker"));
            });
          },
        ),
    
        drawer: SideBar(updateParking: _updateParking),
    
        //? Container ?
        body: Column(
          children: [
            // Affiche la liste de recherche d'adresse en fonction de l'action écoutée dans TopAppBar
            isAddressFieldEditing
                ? Expanded(
                    flex: 1,
                    child: Container(
                        // height: 1,
                        // color: Color.fromARGB(0, 39, 23, 23),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 3.0),
                          ),
                        ),
                        child: ListAddress(
                          onAddressTap: _displayDestinationMarker,
                        )),
                  )
                : Container(),
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
                    // center: (() {
                    //   // Si la liste des marqueur possède un marqueur correspondant à une adresse, zoom dessus
                    //   if ( _markers.contains((marker) => marker.key == ObjectKey("address_marker")) ) {
                    //     return _markers.firstWhere((marker) => marker.key == ObjectKey("address_marker")).point;
                    //   }

                    //   // Zoom sur point de la carte
                    //   return LatLng(48.6907359, 6.1825126);
                    // }()),
                    // bounds: LatLngBounds(LatLng(48.6292781, 6.0974121), LatLng(48.7589048, 6.3322449)), //# affiche la zone en délimitant des coins
                    zoom: 14.0,
  
                    // Empêche la rotation
                    interactiveFlags:
                        InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    plugins: [
                      MarkerClusterPlugin(),
                    ],
                    //todo Au Zoom 14, afficher titre de 3 parkings, 15 : 3 de +
                    onPositionChanged: (MapPosition position, bool hasGesture) {
                      
                      // if (kDebugMode) {
                      //   print(position.zoom);
                      // }

                      if (position.zoom != null) {
                        if (position.zoom! >= 15.42) {
                          areParkingTitleVisible['all'] = true;
                        } else {
                          areParkingTitleVisible['all'] = false;
                        }
    
                        if (position.zoom! >= 14.80) {
                          areParkingTitleVisible['six'] = true;
                        }
    
                        if (position.zoom! >= 14.3 && position.zoom! < 14.80) {
                          areParkingTitleVisible['three'] = true;
                          areParkingTitleVisible['six'] = false;
                          isBikeMinPopupVisible = true;
                        }
    
                        if (position.zoom! < 14.3) {
                          areParkingTitleVisible['three'] = false;
                          areParkingTitleVisible['six'] = false;
                          isBikeMinPopupVisible = false;
                        }
                      }
                    },
    
                    // //TODO: Make hide popup when tap map work
                    // onTap: (_, __) => _popupController.hidePopupsOnlyFor(_markers)
                    //TODO: placer destination avec un onLongPress: ,
                    onTap: (_, __) {
                      setState(() {
                        // S'il y la petite card de parking et la liste d'adresse, réduit la petite card.
                        // S'il n'y a que la liste d'adresse, la réduit
                        if (isAddressFieldEditing) {
                          if (gny(context, listen: false).selectedParking !=
                              null) {
                            if (isParkCardSelected) {
                              isParkCardSelected = false;
                            } else {
                              gny(context, listen: false).selectedParking = null;
                            }
                          } else {
                            isAddressFieldEditing = false;
                          }
                        } else {
                          // Si la grande "card" de Parking est affichée, la réduit, et c'est la petit, l'enlève
                          isParkCardSelected
                              ? isParkCardSelected = false
                              : gny(context, listen: false).selectedParking =
                                  null;
                        }
                      });
                    },
    
                    ),
                layers: [
                  TileLayerOptions(
                    minZoom: 1, //? Global? ? 1 ?
                    maxZoom: 19, //? Global? 18 ? 19 max for classic OSM server
                    backgroundColor: Colors.black,
                    urlTemplate:
                        // Carte OSM 
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",

                        // Carte OSM France : plus de détails, noms des pays et villes étranger en français
                        // chargement des tiles un plus lent
                        // "https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png",
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
                        // markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
                          popupSnap: PopupSnap.markerTop,
                          //todo: rajouter des conditions comme dans proto en fonction du service selectionné
                          popupController: 
                              // Affiche les popup sauf pour les marqueur d'adresse et les stations de vélo
                              // PopupController().showPopupsOnlyFor(
                              //   _markers.where((marker) => marker.key == ObjectKey("parking_marker")).toList()
                              // ),
                              PopupController(
                                  initiallySelectedMarkers: _markers
                                      .where((marker) =>
                                          marker.key != ObjectKey("address_marker")
                                          && marker.key != ObjectKey("bikeStation_marker")).toList()),
    
                          popupBuilder: (_, marker) {
    
                            //todo test sur key value ?
                            if (marker.key == const ObjectKey("parking_marker")) {
                              if(!gny(context, listen: false).isGnyConnection) {
                                return SizedBox(
                                  height: 20,
                                  width: 10,
                                  child: Text(
                                    "?",
                                    style: TextStyle(
                                      color: Colors.red
                                    ),
                                  ),
                                );
                              } else {

                              }
                              return ParkingPopup(
                                  markers: _markers,
                                  marker: marker,
                                  parkingTitle: areParkingTitleVisible);
                            }
                            if (marker.key == const ObjectKey("bikeStation_marker")) {
                              return BikestationPopup(
                                marker: marker,
                                // isBikeMinPopupVisible: isBikeMinPopupVisible
                              );
                            }
                            return Container();
    
                            // //TODO: faire une fonction switch case de popup qui gère tout les type de popup
                            // if (marker.key != ObjectKey("address_marker") &&
                            //     marker.key != ObjectKey("bikeStation_marker")) {
                            //   return ParkingPopup(
                            //       markers: _markers,
                            //       marker: marker,
                            //       parkingTitle: areParkingTitleVisible);
                            // }
                            // return Container();
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
    
            //TODO: to fix : Bug affichage quand Up et white screen quand down
            //? remonter le MediaQuery.of des cards ? Utiliser Navigator ?
            Expanded(
              flex: isParkCardSelected
                  ? isPortrait
                      ? 0
                      : 3
                  : 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: 3.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AnimatedSize(
                        duration: Duration(milliseconds: 400),
                        // reverseDuration: Duration(milliseconds: 0),
                        curve: Curves.linear,
                        child: Container(
                          // color: Color(0xFFE5E5E5),
                          color: Theme.of(context).cardColor,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          child: gny(context, listen: true).selectedParking !=
                                  null
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
              ),
            )
          ],
        ),
    
        ///
        /// Bar de selection des icones sur la map
        ///
        //? Better Icon ? Global ?
        //! attention, appellé une méthode avec (),n'est pas comme la passer en paramètre
        bottomNavigationBar: MainBottomAppBar(onUpdateTap: (String selectedMarkers) {
          setState(() {
            //todo repenser actio botto : deuxieme presse = mise à jour static ? dynamic ?
            switch (selectedMarkers) {
    
              case "parkings":
              // Si parkings est déjà sélectionné : mis à jour des données dynamiques (disponibilité dans popup)
              if(store(context, listen: false).userSelection == "parkings") {
                _updatePopupParkings();
              } else {
                store(context, listen: false).userSelection = "parkings";
                _setParkingsMarkers();
              }
                break;
    
              case "bikeStations":
              // Si parkings est déjà sélectionné : mis à jour des données dynamiques (disponibilité dans popup)
              if(store(context, listen: false).userSelection == "bikeStations") {
                //?prévoir un update et mettre le scaffold dedans ?
                _updateBikeStations();
                
              } else {
                store(context, listen: false).userSelection = "bikeStations";
                gny(context, listen: false).selectedParking = null;
                isParkCardSelected = false;
                _setBikeStationsMarkers();
              }
                break;
              default:
              // TODO : parking si app accès sur parking, sinon autre
            }
          });
        }),
      ),
    );
  }
}


