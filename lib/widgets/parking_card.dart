import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nancy_stationnement/utils/hex_color.dart';
import 'package:nancy_stationnement/services/gny_parking.dart';

class ParkingCard extends StatelessWidget {
  const ParkingCard({
    Key? key,
  }) : super(key: key);

  final gny = Provider.of<GnyParking>;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 375,
      child: Wrap(

          children: [
            Row(children: [Text("1"), Text("2")]),
            GestureDetector(
              onTap: () => print("yes"),
              child: Row(children: [Text("3"), Text("4")])),
          ],
        
      ),
    );
  }
}
