import 'package:flutter/material.dart';
import 'package:nancy_stationnement/screens/home_screen.dart';

///
/// Fonction main
///
void main() async {
  runApp(const MaterialApp(
    // Set it to false in release version
    debugShowCheckedModeBanner: true,
    //TODO:vmanage here themMode
    home: NancyStationnementApp(),
  ));
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
