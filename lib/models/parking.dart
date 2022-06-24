import 'dart:convert';

//TODO: comment
//? parking + héritage parking_gny ?
class Parking {

  final String? id;
  final String? name;
  final List<double> coordinates;

  // final String? description;
  final String? addressNumber;
  final String? addressStreet;
  final String? phone;
  final String? website;
  
  final String? disabled;
  final String? charging;
  final String? maxHeight;
  final String? type; // souterrain, multi étage etc...
  final String? operator;

  final String? fee; //? useless ?
  final Map<String, String>? prices;
  // final String? price30Min;
  // final String? price60Min;
  // final String? price120Min;
  // final String? price240Min;

    
  // final String? maxStay;
  //? à insérer ultéreurement ?
  // final String? bicycle; //? place pour vélo dans le parking. Donnée pour 1 seul parking actuellement

  //Dynamic data
  int? available;
  int? capacity;
  bool isClosed;
  String? colorText;
  String? colorHexa;
  
   //? couplage fort? Faire héritage ? Parking -> Parking_Gny _> Parking_Gny_OSM
   //? Donnée à insérer côté g-ny
  // final int? osmID;

  Parking({
    this.id,
    this.name,
    required this.coordinates,

    // this.description,
    this.addressNumber,
    this.addressStreet,
    this.phone,
    this.website,

    this.disabled,
    this.charging,
    this.maxHeight,
    this.type,
    this.operator,

    this.fee,
    this.prices, //* via mgn mais via osm avant
    // this.price30Min,
    // this.price60Min,
    // this.price120Min,
    // this.price240Min,

    // Dynamic data
    this.available,
    this.capacity,
    this.isClosed = false,
    this.colorText,
    this.colorHexa,
  });

  Parking copyWith({

  String? id,
  String? name,
  List<double>? coordinates,

  // String? description,
  String? addressNumber,
  String? addressStreet,
  String? address, //? MGN or OSM source, you have to choose.
  String? phone,
  String? website,
  
  String? disabled,
  String? charging,
  String? maxHeight,
  String? type, // souterrain, multi étage etc...
  String? operator,

  String? fee,
  Map<String, String>? prices,
  // String? price30Min,
  // String? price60Min,
  // String? price120Min,
  // String? price240Min,

  //Dynamic data
  int? available,
  int? capacity,
  bool isClosed = false,
  String? colorText,
  String? colorHexa,

  }) => Parking(
    
    id: id ?? this.id,
    name: name ?? this.name,
    coordinates: coordinates ?? this.coordinates,

    // description: description ?? this.description,
    addressNumber: address ?? this.addressNumber,
    addressStreet: address ?? this.addressStreet,
    phone: phone ?? this.phone,
    website: website ?? this.website,

    disabled: disabled ?? this.disabled,
    charging: charging ?? this.charging,
    maxHeight: maxHeight ?? this.maxHeight,
    type: type ?? this.type,
    operator: operator ?? this.operator,
    fee: fee ?? this.fee,

    prices: prices ?? this.prices,
    // price30Min: price30Min ?? this.price30Min,
    // price60Min: price60Min ?? this.price60Min,
    // price120Min: price120Min ?? this.price120Min,
    // price240Min: price240Min ?? this.price240Min,

    available: available ?? this.available,
    capacity: capacity ?? this.capacity,
    isClosed: isClosed,
    colorText: colorText ?? this.colorText,
    colorHexa: colorHexa ?? this.colorHexa,
  );

  //
  // Convertir données reçu depuis l'API en objet Parking
  // TODO: devrait se trouver dans service OU ce modele est couplage fort (oui ?)
  //
  factory Parking.fromAPIJson(Map<String, dynamic> json) {
    return Parking(
      id: json["id"] == null ? null : json["id"],
      name: json["name"] == null ? null : json["name"],
      coordinates: List<double>.from(
          json["geometry.coordinates"].map((x) => x.toDouble())),

      // description: json["description"] == null ? null : json["description"],
      addressNumber: json["addr:housenumber"] == null ? null : json["addr:housenumber"],
      addressStreet: json["addr:street"] == null ? null : json["addr:street"],
      phone: json["contact:phone"] == null ? null : json["contact:phone"],
      website: json["website"] == null ? null : json["website"],

      disabled: json["capacity:disabled"] == null ? null : json["capacity:disabled"],
      charging: json["capacity:charging"] == null ? null : json["capacity:charging"],
      maxHeight: json["maxheight"] == null ? null : json["maxheight"],
      type: json["parking"] == null ? null : json["parking"],
      operator: json["operator"] == null ? null : json["operator"],

      fee: json["fee"] == null ? null : json["fee"],
      prices: json["mgn:prices"] == null ? null : Map.from(json["mgn:prices"]).map((k, v) => MapEntry<String, String>(k, v)), //todo: map fonction to have key: horaire, value: price ?
      // price30Min: json["price30Min"] == null ? null : json["price30Min"],
      // price60Min: json["price60Min"] == null ? null : json["price60Min"],
      // price120Min: json["price120Min"] == null ? null : json["price120Min"],
      // price240Min: json["price240Min"] == null ? null : json["price240Min"],
    );
  }

  //
  // Convertir données reçu depuis l'API en objet Parking
  // //? Le faire dans le service ??
  //
  // factory Parking.fromAPIDynamicDataJson(Map<String, dynamic> json) {
  //   return Parking(
  //     capacity: ,
  //     available: ,
  //     isClosed: ,
  //     colorHexa: ,
  //     colorText: ,
  //   );
  // }


}
  