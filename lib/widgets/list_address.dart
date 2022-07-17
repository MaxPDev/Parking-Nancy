import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:nancy_stationnement/services/ban_service.dart';
import 'package:nancy_stationnement/models/address.dart';

class ListAddress extends StatelessWidget {
  const ListAddress({
    Key? key,
  }) : super(key: key);

  // final BanService Function(BuildContext context, {bool listen}) ban;

  final ban = Provider.of<BanService>;

  @override
  Widget build(BuildContext context) {
    List<Address> addressList = ban(context, listen: true).addressList;

    return addressList.length != null ? 
    ListView.builder(
      itemCount: ban(context, listen: true).addressList.length,
      itemBuilder: (context, index) {

        Address address = addressList[index];

        //todo: listview divider + ascensor ? + number / street / city apparence
        //todo: affichage list + probleme saisie
        return ListTile(
          title: Text("${address.label}"),
          onTap: () => print("${address.id}"), //todo generate marker
          tileColor: Color.fromARGB(255, 210, 236, 211),
          selectedTileColor: Colors.green,
          focusColor: Colors.red,
          
        );
      }
    )
    :
    Container();
  }
}
