import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:nancy_stationnement/screens/home_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:nancy_stationnement/services/gny_parking.dart';
import 'package:nancy_stationnement/services/ban_service.dart';
import 'package:nancy_stationnement/services/jcdecaux_velostan.dart';
import 'package:nancy_stationnement/services/store.dart';
// import 'package:nancy_stationnement/services/global_text.dart';

/// Fonction main
void main() async {
  //! Could be not safe (https permissions)
  HttpOverrides.global = MyHttpOverrides();

  /// Affiche le Splashscreen avec [FlutterNativeSplash.preserve] jusqu'à que [FlutterNativeSplashRemove] soit invoqué.
  //* Ces deux lignes sont à supprimé pour un affichage plus bref.
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// Configuration des servicies dans le MultiProvider
  runApp(MultiProvider(
      providers: [
        /// Service G-Ny
        ChangeNotifierProvider(
          create: (context) => GnyParking(),
        ),
        /// Service Base National Adresse
        ChangeNotifierProvider(
          create: (context) => BanService(),
        ),
        /// Service JCDecaux
        ChangeNotifierProvider(
          create: (context) => JcdecauxVelostan(),
        ),
        ChangeNotifierProvider(
          create: (context) => Store(),
        ),
      ],
      child: MaterialApp(

        // Choisit le theme du téléphone
        themeMode: ThemeMode.system,

        // Darkmode
        darkTheme: ThemeData.dark(),

        // Thème principal : text, couleur excepter icone et boite de dialogue
        theme: ThemeData(

          textTheme: TextTheme(
            
            // Style du titre dans la side bar
            headline1: TextStyle(
              color: Colors.grey[100],
              fontSize: 24,
              fontWeight: FontWeight.w500
            ),

            // Style du titre dans la top app bar
            headline2: TextStyle(
              color: Colors.grey[100],
              fontSize: 18,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.visible
            ),

            // Style du titre dans la Parking Card
            headline3: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),

            // Style Titre dans la Mini Parking Card et la BikeStation Popup
            headline4: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),

            // Titre et text dans les boites de dialogue
            // headline6: ,
            // subtitle1: ,

            // Style de la "zone" dans la Mini Parking Card et la Parking Card
            overline: const TextStyle(
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              letterSpacing: 1
            ),

            // Style du nombre de place dans Mini Parking card et Parking Card
            //* (Couleur gérée dans leur widgets)
            subtitle2: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),

            // Style du titre des options de la side bar
            bodyText1: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700
            ),

            // Style du Texte des cards, de la popup Velostan et des déscription dans la sidebar
            // sauf les messages en cas de parkings ou stations fermés
            bodyText2: const TextStyle(
              fontSize: 15,
            )

          ),

          // Couleur de la main bottom app bar
          primaryColor: const Color.fromARGB(255, 92, 212, 92),
          primaryColorLight: const Color.fromARGB(255, 168, 207, 169),



          // Theme de la top app bar 
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 31, 77, 33),
            ),

          // Theme de la side bar
          drawerTheme: DrawerThemeData(
            backgroundColor: Colors.green[200]
          ),

          // Couleur de le parking card
          cardColor: const Color(0xFFE5E5E5),

          // Couleur de fond des boite de dialogue : message d'acceuil et d'exit
          dialogBackgroundColor: const Color(0xFFE5E5E5),

          // Couleur principal de la main bottom app bar
          bottomAppBarColor: const Color.fromARGB(255, 92, 212, 92)
        ),

        // darpeaux "debug" en haut de l'écran
        debugShowCheckedModeBanner: false,

        // Appelle la classe général de l'application
        home: const NancyStationnementApp(),
      )));
}


/// Classe principale
class NancyStationnementApp extends StatelessWidget {
  const NancyStationnementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bloquer l'appli en mode portrait 
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

    return const SafeArea(
      // Appelle la seule page de l'application
      child: HomeScreen()
    );
  }
}

//! Certificat
//TODO: Activer SSL
// https://stackoverflow.com/questions/54285172/how-to-solve-flutter-certificate-verify-failed-error-while-performing-a-post-req
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
//? Peut-être utile à un moment : 
// allowAutoSignedCert = true;

