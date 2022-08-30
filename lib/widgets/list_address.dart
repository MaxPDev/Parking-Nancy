import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:nancy_stationnement/services/ban_service.dart';
import 'package:nancy_stationnement/models/address.dart';
import 'package:nancy_stationnement/widgets/items.dart';

class ListAddress extends StatelessWidget {
  const ListAddress({
    Key? key,
    required this.onAddressTap,
  }) : super(key: key);

  // final BanService Function(BuildContext context, {bool listen}) ban;

  // Serivce ban depuis le provider
  final ban = Provider.of<BanService>;
  final Function onAddressTap;

  double roundDistanceInKm(distanceInMeters) {
    return double.parse((distanceInMeters/100).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
  double width = MediaQuery.of(context).size.width;

    // liste des adresses depuis le service ban
    List<Address> addressList = ban(context, listen: true).addressList;

    return addressList.isNotEmpty ? 
    ListView.separated(
      // shrinkWrap: true,
      itemCount: ban(context, listen: true).addressList.length,
      separatorBuilder: (context, index) => DividerQuart(width: width),
      itemBuilder: (context, index) {

        Address address = addressList[index];

        return ListTile(

          isThreeLine: true,

          // leading: Text("${address.housenumber}"),
          subtitle: Text("${address.postcode} ${address.city}"),
          title: Text("${address.name}"),
          // trailing: Text("${roundDistanceInKm(address.distance)} km", style: TextStyle(fontStyle: FontStyle.italic),),

          onTap: () {
            ban(context, listen: false).selectedDestinationAddress = address;
            ban(context, listen: false).generateDistinationAdresseMarker();
            onAddressTap();
          } ,
          // onLongPress: ,(//todo generate marker too ?)

          tileColor: const Color.fromARGB(255, 210, 236, 211),
          selectedTileColor: Colors.green,
          focusColor: Colors.greenAccent,

          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(21)),

          dense: false,
          visualDensity: const VisualDensity(vertical: -4),
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
