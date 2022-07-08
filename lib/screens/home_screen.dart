import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:nancy_stationnement/services/gny_parking.dart';

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

  List<Marker> _markers = [];

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
    return Scaffold(
      // BottomBar
      //TODO: Doit être une search bar, ou celle-ci doit être en dessous.
      appBar: AppBar(
        //TODO: make and use global var/settings
        title: const Text("Nancy Stationnement Application"),
      ),

      body: Container(
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
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
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
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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

      ///
      /// Bar de selection des icones sur la map
      ///
      ///
      // TODO: This must be a Widget
      //? Better Icon ? Global ?
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 92, 212, 92), //TODO: Global
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("button");
                  }
                },
                icon: const Icon(Icons.directions_walk)),
            IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("button");
                  }
                },
                icon: const Icon(Icons.directions_bus)),
            IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("button");
                  }
                },
                icon: const Icon(Icons.directions_bike)),
            IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("button");
                  }
                },
                icon: const Icon(Icons.local_parking)),
            IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("MAJ");
                    gny(context, listen: false)
                        .initParkingAndGenerateMarkers()
                        .then((value) => {
                              setState(() {
                                _markers =
                                    // GnyParking().getParkingsMarkers();
                                    gny(context, listen: false)
                                        .getParkingsMarkers();
                              }),
                            });
                  }
                },
                icon: const Icon(Icons.update)),
          ],
        ),
      ),
    );
  }
}
