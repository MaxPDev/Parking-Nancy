import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nancy_stationnement/screens/home_screen.dart';
import 'package:nancy_stationnement/services/gny_parking.dart';

///
/// Fonction main
///
void main() async {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GnyParking(),
        )
      ],
      child: const MaterialApp(
        // Set it to false in release version
        debugShowCheckedModeBanner: true,
        //TODO:vmanage here themeMode
        home: NancyStationnementApp(),
      )));
}

///
/// Classe principale
///
class NancyStationnementApp extends StatelessWidget {
  const NancyStationnementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
