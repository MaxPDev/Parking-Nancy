import 'package:flutter/material.dart';

///
/// Fonction main
///
void main() {
  runApp(const MaterialApp(
    // Set it to false in release version
    debugShowCheckedModeBanner: true,
    //TODO:manage here themMode
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
    return const Text("first test");
  }
}
