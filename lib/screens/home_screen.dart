import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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

import 'package:nancy_stationnement/text/app_text.dart' as text;

/// HomeScreen gère l'affichage de la map, écran principal de l'application.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Contrôle les changements sur la carte, tel que le zoom, la rotation, le déplacement etc...
  final MapController _mapController = MapController();

  /// Providers du service store
  final store = Provider.of<Store>;

  /// Providers du service G-Ny
  final gny = Provider.of<GnyParking>;

  /// Providers du serice Base National Adresse
  final ban = Provider.of<BanService>;

  /// Providers du service JCDecaux
  final bikeStations = Provider.of<JcdecauxVelostan>;

  /// Liste des marqueurs
  List<Marker> _markers = [];

  /// Si la min parking card est selectionné/glissé ou non
  bool isParkCardSelected = false;

  /// Si le champ d'édition d'adresse est actif
  bool isAddressFieldEditing = false;

  /// Nombre de nom de parkings visible depuis la carte
  //TODO: Logique à repenser
  Map areParkingTitleVisible = {'three': false, 'six': false, 'all': false};

  /// Marqueur de l'adresse sélectionnée
  Marker? addressMarker;

  /// Message de succès de mise à jour de la disponibilité/couleur des parkings
  final snackBarPopupParking = const SnackBar(
    content: Text(text.parkingsAvailabiltyUpdated,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
    backgroundColor: Colors.blue,
    duration: Duration(seconds: 3),
    elevation: 5,
  );

  /// Message de succès de mise à jour de la disponibilité/couleur des parkings
  final snackBarPopupBikeStation = const SnackBar(
    content: Text(text.bikeStationsAvailabiltyUpdated,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 3),
    elevation: 5,
  );

  /// Message de succès de mise à jour des données statiques des parkings
  final snackBarParking = const SnackBar(
    content: Text(text.parkingsDataUpdated,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
    backgroundColor: Colors.blue,
    elevation: 5,
  );

  /// Message d'erreur en cas d'échec d'une récupération des données
  final snackBarConnexionError = const SnackBar(
    duration: Duration(seconds: 7),
    content: Text(text.connexionError,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
    backgroundColor: Colors.red,
    elevation: 5,
  );

  //* Parkings

  /// Initie la récupération des parkings et la génération de leur marqueurs.
  _initParkingMarkers() {
    gny(context, listen: false)
        .initParkingAndGenerateMarkers()
        .then((value) => {
              setState(() {
                // S'il n'y pas de connexion, message d'erreur. Sinon, les marqueurs sont récupérés.
                if (gny(context, listen: false).isGnyConnection == false) {
                  // Fin du splash screen
                  FlutterNativeSplash.remove();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBarConnexionError);
                } else {
                  // Récupère les marqueurs des parkings générés
                  _markers = gny(context, listen: false).getParkingsMarkers();
                  // Fin du splash screen
                  FlutterNativeSplash.remove();
                }
              }),
            });
  }

  /// Met à jour des données de parkings
  _updateParking() {
    gny(context, listen: false)
        .reInitParkingAndGenerateMarkers()
        .then((value) => {
              setState(() {
                // Récupère les marqueurs des parkings générés
                _markers = gny(context, listen: false).getParkingsMarkers();

                // Si une adresse à été sélectionnée, le marqueur correspondant est rajouté dans la liste des marqueurs
                if (ban(context, listen: false).selectedDestinationMarker !=
                    null) {
                  _markers.add(
                      ban(context, listen: false).selectedDestinationMarker!);
                }

                // S'il n'y a pas de connexion, affiche message d'erreur
                if (gny(context, listen: false).isGnyConnection == false) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBarConnexionError);
                } else {
                  // Affiche le message de succès de mise à jour
                  ScaffoldMessenger.of(context).showSnackBar(snackBarParking);

                  // Met à jour la sélection de l'utilisateur sur parkings
                  store(context, listen: false).userSelection = "parkings";
                }
              }),
            });
  }

  /// Met à jour les données dynamiques des parkings : disponibilité, couleurs...
  _updatePopupParkings() {
    gny(context, listen: false).initParkingAndGenerateMarkers().then((value) =>
        {
          setState(() {
            // Récupère les marqueurs de parkings
            _markers = gny(context, listen: false).getParkingsMarkers();

            // Si une adresse à été sélectionnée, le marqueur correspondant est rajouté dans la liste des marqueurs
            if (ban(context, listen: false).selectedDestinationMarker != null) {
              _markers
                  .add(ban(context, listen: false).selectedDestinationMarker!);
            }

            // S'il n'y a pas de connexion, affiche message d'erreur
            if (gny(context, listen: false).isGnyConnection == false) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBarConnexionError);
            } else {
              // Affiche le message de succès de mise à jour
              ScaffoldMessenger.of(context).showSnackBar(snackBarPopupParking);
            }
          }),
        });
  }

  /// Rempli la liste des marqueurs par ceux des parkigns
  _setParkingsMarkers() {
    // Récupère la liste des marqueur de parkings
    _markers = gny(context, listen: false).getParkingsMarkers();

    // Si une adresse à été sélectionnée, le marqueur correspondant est rajouté dans la liste des marqueurs
    if (ban(context, listen: false).selectedDestinationMarker != null) {
      _markers.add(ban(context, listen: false).selectedDestinationMarker!);
    } else {
      // Sinon, supprime le marqueur de l'adresse éventuellement selectionnée précédemment
      _markers.removeWhere(
          (marker) => marker.key == const ObjectKey("address_marker"));
    }

    // S'il n'y a pas de connexion, affiche message d'erreur
    if (gny(context, listen: false).isGnyConnection == false) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarConnexionError);
    }
  }

  //* Stations de location de Vélo

  /// Initie la récupération des stations de location de vélo et la génération de leur marqueur.
  _initBikeStations() {
    bikeStations(context, listen: false).initStations().then((value) {
      bikeStations(context, listen: false).generateStationsMarker();
    });
  }

  // Met à jour les données des vélos
  _updateBikeStations() {
    bikeStations(context, listen: false).initStations().then((value) {
      setState(() {
        // Récupère la liste des marqueur de station de vélo
        _markers = bikeStations(context, listen: false).stationMarkers;

        // Si une adresse à été sélectionnée, le marqueur correspondant est rajouté dans la liste des marqueurs
        if (ban(context, listen: false).selectedDestinationMarker != null) {
          _markers.add(ban(context, listen: false).selectedDestinationMarker!);
        }

        // S'il n'y a pas de connexion, affiche message d'erreur
        if (gny(context, listen: false).isGnyConnection == false) {
          ScaffoldMessenger.of(context).showSnackBar(snackBarConnexionError);
        } else {
          // Si la lise des marqueurs des stations de vélo et vide, relance de l'initialisation.
          // Sinon, génère les marqueurs des stations
          bikeStations(context, listen: false).stationMarkers.isEmpty
              ? _initBikeStations()
              : bikeStations(context, listen: false).generateStationsMarker();

          // Affiche le message de succès de mise à jour
          ScaffoldMessenger.of(context).showSnackBar(snackBarPopupBikeStation);
        }
      });
    });
  }

  /// Rempli la liste des marqueurs par ceux des stations de location de vélos
  _setBikeStationsMarkers() {
    // Récupère la liste des marqueur de station de vélo
    _markers = bikeStations(context, listen: false).stationMarkers;

    // Si une adresse à été sélectionnée, le marqueur correspondant est rajouté dans la liste des marqueurs
    if (ban(context, listen: false).selectedDestinationMarker != null) {
      _markers.add(ban(context, listen: false).selectedDestinationMarker!);
    } else {
      // Sinon, supprime le marqueur de l'adresse éventuellement selectionnée précédemment
      _markers.removeWhere(
          (marker) => marker.key == const ObjectKey("address_marker"));
    }

    // S'il n'y a pas de connexion, affiche message d'erreur
    if (gny(context, listen: false).isGnyConnection == false) {
      ScaffoldMessenger.of(context).showSnackBar(snackBarConnexionError);
    }
  }

  //* Marqueur de localisation / d'adresse

  /// Affiche le marqueur de la destination
  _displayDestinationMarker() {
    // Supprime un marqueur adresse éventuellement déjà présent dans la liste des marqueurs
    _markers.removeWhere(
      (marker) => marker.key == const ObjectKey("address_marker"),
    );

    // Rajoute le marqueur de l'adresse sélectionnée
    _markers.add(ban(context, listen: false).selectedDestinationMarker!);

    setState(() {
      // Déplace la carte vers le marqueur de l'adresse sélectionnée.
      _mapController.move(
          ban(context, listen: false).selectedDestinationMarker!.point, 16);
    });
  }

  @override
  void initState() {
    super.initState();

    /// Initialise les marqueurs des marqueurs, les données des station de vélo et le message d'acceuil une fois la mise en page prête.
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // Initialisation des marqueurs de parkings
      _initParkingMarkers();
      // Initialisation des station de location de vélo
      _initBikeStations();
      // Affichage du message d'acceui/avertissement
      _displayWelcomeMessage();
    });
  }

  /// Message d'accueil/d'avertissement
  Future<bool> _displayWelcomeMessage() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(text.welcomeTitle),
            content: const Text(
              text.welcomeText,
              // textAlign: TextAlign.justify,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(text.welcomeConfirm),
              ),
            ],
          ),
        )) ??
        false;
  }

  /// Message de sortie d'application
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(text.quitTitle),
            content: const Text(text.quitMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(text.quitNo),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(text.quitYes),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    /// Détection de l'orientation de l'appareil
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // Top App Bar
        appBar: TopAppBar(
          // Fonction déclenchée à l'édition d'une adresse
          onEdition: () {
            // Si l'édtion est active, [isAddressFieldEditing] passe à true.
            if (!isAddressFieldEditing) {
              setState(() {
                isAddressFieldEditing = true;
              });
            }
          },
          // Fonction déclenché à la sortie de l'édition d'une adresse
          onClose: () {
            setState(() {
              // [isAddressFieldEditing] passe à faux
              isAddressFieldEditing = false;

              // Suppression du marqueur correspondant à l'adresse sélectionnée.
              _markers.removeWhere(
                  (marker) => marker.key == const ObjectKey("address_marker"));

              // Mise à jour du marqueur de l'adresse sélectionnée à null
              ban(context, listen: false).selectedDestinationMarker = null;
            });
          },
        ),

        // Sidebar
        drawer: SideBar(updateParking: _updateParking),

        body: Column(
          children: [
            // Affiche la liste de suggestion d'adresse en fonction de [isAddressFieldEditing]
            isAddressFieldEditing
                ? Expanded(
                    flex: 1,
                    child: Container(
                        decoration: const BoxDecoration(
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
                options: MapOptions(
                  // Centré au centre de la ville
                  center: LatLng(48.6907359, 6.1825126),
                  zoom: 14.0,

                  // Empêche la rotation
                  interactiveFlags:
                      InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                  plugins: [
                    MarkerClusterPlugin(),
                  ],

                  // Active ou désactive le nombre de titre de parking directement visible dans les popup
                  // selon le niveau de zoom
                  //TODO: Logique à repenser
                  onPositionChanged: (MapPosition position, bool hasGesture) {
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
                      }

                      if (position.zoom! < 14.3) {
                        areParkingTitleVisible['three'] = false;
                        areParkingTitleVisible['six'] = false;
                      }
                    }
                  },

                  //? placer destination avec un onLongPress
                  onTap: (_, __) {
                    setState(() {
                      // S'il y a la petite card de parking et la liste d'adresse, réduit la petite card.
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
                          popupSnap: PopupSnap.markerTop,
                          popupController:
                              PopupController(
                                // Popups affichés dès le début : uniquement ceux des parkings
                                  initiallySelectedMarkers: _markers
                                      .where((marker) =>
                                          marker.key !=
                                              const ObjectKey(
                                                  "address_marker") &&
                                          marker.key !=
                                              const ObjectKey(
                                                  "bikeStation_marker"))
                                      .toList()),
                          popupBuilder: (_, marker) {
                            // Affiche les popup des parkings si les marqueurs sont ceux des parkings
                            if (marker.key ==
                                const ObjectKey("parking_marker")) {
                              // Affiche si pas de connexion
                              if (!gny(context, listen: false)
                                  .isGnyConnection) {
                                return const SizedBox(
                                  height: 20,
                                  width: 10,
                                  child: Text(
                                    "?",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              } else {

                              return ParkingPopup(
                                  // markers: _markers,
                                  marker: marker,
                                  parkingTitle: areParkingTitleVisible);}
                            }
                            if (marker.key ==
                                const ObjectKey("bikeStation_marker")) {
                              
                              // Affichage si pas de connexion
                              if (!gny(context, listen: false)
                                  .isGnyConnection) {
                                return SizedBox(
                                  height: 20,
                                  width: 30,
                                  child: Container(
                                    color: const Color.fromRGBO(210, 255, 197, 0.9),
                                    child: const Text(
                                      "?",
                                      style: TextStyle(color:Colors.red, fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              } else {

                              return BikestationPopup(
                                marker: marker,
                                // // // isBikeMinPopupVisible: isBikeMinPopupVisible
                              );}
                            }
                            return Container();

                            //? faire une fonction switch case de popup qui gère tout les type de popup
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
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: 3.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AnimatedSize(
                        duration: const Duration(milliseconds: 400),
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
                                    // drag up
                                    if (details.delta.dy < 1) {
                                      if (!isParkCardSelected) {
                                        setState(() {
                                          isParkCardSelected = true;
                                        });
                                      }
                                    } else {
                                      // drag down
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
                                      ? const ParkingCard()
                                      // ? isPortrait ? ParkingCard() : Text("from home")
                                      : const MinParkingCard()) //todo Gesture doctor : miniCard, onTruc : Card (column->row->column)
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
        bottomNavigationBar:
            MainBottomAppBar(onUpdateTap: (String selectedMarkers) {
          setState(() {
            //todo repenser actio botto : deuxieme presse = mise à jour static ? dynamic ?
            switch (selectedMarkers) {
              case "parkings":
                // Si parkings est déjà sélectionné : mis à jour des données dynamiques (disponibilité dans popup)
                if (store(context, listen: false).userSelection == "parkings") {
                  _updatePopupParkings();
                } else {
                  store(context, listen: false).userSelection = "parkings";
                  _setParkingsMarkers();
                  // Rencentre la map à sa position initial
                  // _mapController.move(LatLng(48.6907359, 6.1825126), 14);
                }
                break;

              case "center":
                // Rencentre la map à sa position initial
                _mapController.move(LatLng(48.6907359, 6.1825126), 14);
                break;

              case "bikeStations":
                // Si parkings est déjà sélectionné : mis à jour des données dynamiques (disponibilité dans popup)
                if (store(context, listen: false).userSelection ==
                    "bikeStations") {
                  //?prévoir un update et mettre le scaffold dedans ?
                  _updateBikeStations();
                } else {
                  store(context, listen: false).userSelection = "bikeStations";
                  gny(context, listen: false).selectedParking = null;
                  isParkCardSelected = false;
                  _setBikeStationsMarkers();
                  // Rencentre la map à sa position initial
                  // _mapController.move(LatLng(48.6907359, 6.1825126), 14);
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
