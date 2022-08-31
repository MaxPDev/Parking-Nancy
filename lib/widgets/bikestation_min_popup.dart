import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nancy_stationnement/models/station.dart';

class BikestationMinPopup extends StatelessWidget {
  const BikestationMinPopup({
    Key? key,
    required this.station,
  }) : super(key: key);

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Container(
          height: 60,
          width: 40,
          // color: Color.fromRGBO(216, 212, 212, 0.54),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                decoration: BoxDecoration(
                  color: station.status == "OPEN" ? 
                    const Color.fromRGBO(9, 148, 81, 0.70) :
                    const Color.fromARGB(255, 241, 154, 132),
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(5))
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(
                          FontAwesomeIcons.bicycle,
                          color: Colors.white70,
                          size: 12
                        ),
                        // SizedBox(
                        //   width: 4,
                        // ),
                        Text("${station.bikes}", 
                        style: const TextStyle(
                          fontSize: 14, 
                          color: Colors.white70,
                          fontWeight: FontWeight.bold)),
                      ],
                    ),
                                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        const Icon(
                          FontAwesomeIcons.checkToSlot,
                          color: Colors.white70,
                          size: 12,
                        ),
                        // SizedBox(
                        //   width: 4,
                        // ),
                        Text("${station.stands}", 
                        style: const TextStyle(
                          fontSize: 14, 
                          color: Colors.white70,
                          fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }
}