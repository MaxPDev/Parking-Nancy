import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:http/http.dart';

import 'package:nancy_stationnement/screens/home_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:nancy_stationnement/services/gny_parking.dart';
import 'package:nancy_stationnement/services/ban_service.dart';
import 'package:nancy_stationnement/services/jcdecaux_velostan.dart';
import 'package:nancy_stationnement/services/store.dart';
// import 'package:nancy_stationnement/services/global_text.dart';

///
/// Fonction main
///
void main() async {
  //! Could be not safe (https permissions)
  HttpOverrides.global = new MyHttpOverrides();

  // Splashscreen longer
  //TODO if FlutterNativeSpash.remove is not setup after initialization,
  //TODO no need of these two line
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GnyParking(),
        ),
        ChangeNotifierProvider(
          create: (context) => BanService(),
        ),
        ChangeNotifierProvider(
          create: (context) => JcdecauxVelostan(),
        ),
        ChangeNotifierProvider(
          create: (context) => Store(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => GlobalText(),
        // )
      ],
      child: MaterialApp(
        
        //todo: à mettre par défaut
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(),

        // Thème principal
        // Concerne text et couleur, sauf icones et snackbar
        theme: ThemeData(

          textTheme: TextTheme(
            
            // Titre dans la side bar
            headline1: TextStyle(
              color: Colors.grey[100],
              fontSize: 24,
              fontWeight: FontWeight.w500
            ),

            // Titre dans la top app bar
            headline2: TextStyle(
              color: Colors.grey[100],
              fontSize: 18,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.visible
            ),

            // Titre dans la Parking Card
            headline3: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),

            // Titre dans la Mini Parking Card
            // Titre dans la Bike Station Popup
            headline4: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),

            // Titre et text dans les boites de dialogue
            // headline6: ,
            // subtitle1: ,

            // Utilisé pour la "zone" dans la Mini Parking Card et la Parking Card
            overline: TextStyle(
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              letterSpacing: 1
            ),

            // Sous-titre Nombre de place dans Mini Parking card et Parking Card
            // (Couleur gérée dans leur widgets)
            subtitle2: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),

            // Titre des options de la side bar
            bodyText1: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700
            ),

            // Texte des cards, et la popup Velostan et des déscription dans la sidebar
            // sauf les messages en cas de parkings ou stations fermés
            bodyText2: TextStyle(
              fontSize: 15,
              // fontStyle: FontStyle.italic
            )

          ),

          // Used for main bottom app's buttons
          primaryColor: Color.fromARGB(255, 92, 212, 92),
          primaryColorLight: Color.fromARGB(255, 168, 207, 169),



          // Top app bar theme.
          // Color also used in background color for title card in side bar.
          appBarTheme: AppBarTheme(
            color: Color.fromARGB(255, 31, 77, 33),
            ),
          drawerTheme: DrawerThemeData(
            backgroundColor: Colors.green[200]
          ),

          // Parking card color
          cardColor: Color(0xFFE5E5E5),
          // Welcome message and quit message
          dialogBackgroundColor: Color(0xFFE5E5E5),

          // main bottom app theme
          bottomAppBarColor: Color.fromARGB(255, 92, 212, 92)
        ),
        //TODO: Set it to false in release version
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
    return const SafeArea(
      child: HomeScreen()
    );
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

