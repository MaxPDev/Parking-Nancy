import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:nancy_stationnement/services/ban_service.dart';
import 'package:nancy_stationnement/models/address.dart';
import 'package:nancy_stationnement/widgets/items.dart';

class ListAddress extends StatelessWidget {
  const ListAddress({
    Key? key,
  }) : super(key: key);

  // final BanService Function(BuildContext context, {bool listen}) ban;

  final ban = Provider.of<BanService>;

  double roundDistanceInKm(distanceInMeters) {
    return double.parse((distanceInMeters/100).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
    List<Address> addressList = ban(context, listen: true).addressList;

    return addressList.length != null ? 
    ListView.separated(
      // shrinkWrap: true,
      itemCount: ban(context, listen: true).addressList.length,
      separatorBuilder: (context, index) => DividerQuart(width: width),
      itemBuilder: (context, index) {

        Address address = addressList[index];

        //todo: listview divider + ascensor ? + number / street / city apparence
        //todo: affichage list + probleme saisie + garder le texte saisie dans le champ
        //todo divier et height width en global
        return ListTile(

          isThreeLine: true,

          // leading: Text("${address.housenumber}"),
          subtitle: Text("${address.postcode} ${address.city}"),
          title: Text("${address.name}"),
          trailing: Text("${roundDistanceInKm(address.distance)} km", style: TextStyle(fontStyle: FontStyle.italic),),

          onTap: () => print("${address.id}"), //todo generate marker
          // onLongPress: ,(//todo generate marker too ?)

          tileColor: Color.fromARGB(255, 210, 236, 211),
          selectedTileColor: Colors.green,
          focusColor: Colors.greenAccent,

          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(21)),

          dense: false,
          visualDensity: VisualDensity(vertical: -4),
          // contentPadding: EdgeInsets.fromLTRB(7, 7, 7, 7),

          // horizontalTitleGap: 10,
          // minVerticalPadding: 10,
          // minLeadingWidth: ,
          
        );
      }
    )
    :
    Container();
  }
}
