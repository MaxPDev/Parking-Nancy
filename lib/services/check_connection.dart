import 'dart:async';
import 'dart:io';

class CheckConnection {
  //Check internet connection
  static Future<bool> isGnyConnection() async {
    try {
      final result =
          await InternetAddress.lookup('go.g-ny.org');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      // TODO: Display it on a user screen
      print("Connection to go.g-ny.org not possible. Check your connection, and if go.g-ny.org is still accessible");
      return false;
    }
  }
}
