import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:http/http.dart';

import 'package:nancy_stationnement/screens/home_screen.dart';
import 'package:nancy_stationnement/services/gny_parking.dart';

import 'package:nancy_stationnement/services/ban_service.dart';

///
/// Fonction main
///
void main() async {
  //! Could be not safe (https permissions)
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GnyParking(),
        ),
        ChangeNotifierProvider(
          create: (context) => BanService(),
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
    // Bloquer l'appli en mode portrait //? Temporaire
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return const HomeScreen();
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
//? Peut-être utile à un moment : 
// allowAutoSignedCert = true;

