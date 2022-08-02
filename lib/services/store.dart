// Ce service est utilisé pour gérer les variables d'intéraction de l'utilisateur
// devant être accessible globalement, et n'étant pas gérer par un service particulier

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Store extends ChangeNotifier {

  // Selection de l'utilisateur depuis la main_bottom_app_bar
  String userSelection = "parkings";


  Store() {
    if (kDebugMode) {
      print("Store constructor");
    }
  }



  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
    super.removeListener(listener);
    print("removeListener here");
  }

}