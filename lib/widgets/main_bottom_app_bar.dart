import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nancy_stationnement/services/gny_parking.dart';

class MainBottomAppBar extends StatelessWidget {
  MainBottomAppBar({
    Key? key,
    required this.onUpdateTap
    // required this.gny,
  }) : super(key: key);

  // final GnyParking Function(BuildContext context, {bool listen}) gny;
    // Providers
  final gny = Provider.of<GnyParking>;

  final Function onUpdateTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
                  print("parking button pressed");
                }
              },


              icon: const Icon(Icons.local_parking)),
          IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print("MAJ");
                  gny(context, listen: false)
                      .fetchDynamicDataParkings()
                      .then((value) => {
                        print("fetchDynamicData from MAJ button"),
                        onUpdateTap()
                          });
                }
              },
              icon: const Icon(Icons.update)),
        ],
      ),
    );
  }
}