import 'dart:convert';

const String tableParkings = "parkings";

class ParkingFields {
  static final List<String> values = [
    id,
    name,
    coordinates,

    addressNumber,
    addressStreet,
    address,
    phone,
    website,

    disabled,
    charging,
    maxHeight,
    type,
    operator,
    zone,

    fee,
    prices,

    //* For test purposes only
    osmId,
    osmType,

  ];

  // static final String osmId = "osmId";
  static const String id = "_id";
  static const String name = "name";
  static const String coordinates = "coordinates";

  static const String addressNumber = "addresseNumber";
  static const String addressStreet = "addressStreet";
  static const String address = "address";
  static const String phone = "phone";
  static const String website = "website";

  static const String disabled = "disabled";
  static const String charging = "charging";
  static const String maxHeight = "maxHeight";
  static const String type = "type";
  static const String operator = "operator";
  static const String zone = "zone";

  static const String fee = "fee";
  static const String prices = "prices";

  //* For test purposes only
  static const String osmId = "osmId";
  static const String osmType = "osmType";


  // static final String capacity = "capacity";
}

//? parking + héritage parking_gny ?
class Parking {

  final String? id;
  final String? name;
  final List<double> coordinates;

  // final String? description;
  final String? addressNumber;
  final String? addressStreet;
  final String? address;
  final String? phone;
  final String? website;
  
  final String? disabled;
  final String? charging;
  final String? maxHeight;
  final String? type; // souterrain, multi étage etc...
  final String? operator;
  final String? zone;

  final String? fee; //? useless ?
  final Map<String, String>? prices;
  // final String? price30Min;
  // final String? price60Min;
  // final String? price120Min;
  // final String? price240Min;

  //* For test purposes only
  final String? osmId;
  final String? osmType;

    
  // final String? maxStay;
  //? à insérer ultéreurement ?
  // final String? bicycle; //? place pour vélo dans le parking. Donnée pour 1 seul parking actuellement

  //Dynamic data
  String? available;
  String? capacity;
  bool? isClosed;
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
    this.address,
    this.phone,
    this.website,

    this.disabled,
    this.charging,
    this.maxHeight,
    this.type,
    this.operator,
    this.zone,

    this.fee,
    this.prices, //* via mgn mais via osm avant
    // this.price30Min,
    // this.price60Min,
    // this.price120Min,
    // this.price240Min,

    //* For test purposes only
    this.osmId,
    this.osmType,

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
  String? zone,

  String? fee,
  Map<String, String>? prices,
  // String? price30Min,
  // String? price60Min,
  // String? price120Min,
  // String? price240Min,

  //* For test purposes only
  String? osmId,
  String? osmType,

  //Dynamic data
  String? available,
  String? capacity,
  bool? isClosed = false,
  String? colorText,
  String? colorHexa,

  }) => Parking(
    
    id: id ?? this.id,
    name: name ?? this.name,
    coordinates: coordinates ?? this.coordinates,

    // description: description ?? this.description,
    addressNumber: address ?? this.addressNumber,
    addressStreet: address ?? this.addressStreet,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    website: website ?? this.website,

    disabled: disabled ?? this.disabled,
    charging: charging ?? this.charging,
    maxHeight: maxHeight ?? this.maxHeight,
    type: type ?? this.type,
    operator: operator ?? this.operator,
    fee: fee ?? this.fee,
    zone: zone ?? this.zone,

    prices: prices ?? this.prices,
    // price30Min: price30Min ?? this.price30Min,
    // price60Min: price60Min ?? this.price60Min,
    // price120Min: price120Min ?? this.price120Min,
    // price240Min: price240Min ?? this.price240Min,

    //* For test purposes only
    osmId: osmId ?? this.osmId,
    osmType: osmType ?? this.osmType,

    // Dynamic Data
    available: available ?? this.available,
    capacity: capacity ?? this.capacity,
    isClosed: isClosed,
    colorText: colorText ?? this.colorText,
    colorHexa: colorHexa ?? this.colorHexa,
  );

  //
  // Convertir données reçu depuis l'API en objet Parking
  //
  factory Parking.fromAPIJson(Map<String, dynamic> json) {
    return Parking(
      id: json["id"],
      name: json["name"],
      coordinates: List<double>.from(
          json["geometry.coordinates"].map((x) => x.toDouble())),

      // description: json["description"] == null ? null : json["description"],
      addressNumber: json["addr:housenumber"],
      addressStreet: json["addr:street"],
      address: json["mgn:address"],
      phone: json["contact:phone"],
      website: json["website"],

      disabled: json["capacity:disabled"],
      charging: json["capacity:charging"],
      maxHeight: json["maxheight"],
      type: json["parking"],
      operator: json["operator"],
      zone: json["mgn:zone"],

      fee: json["fee"],
      prices: json["mgn:prices"] == null ? {"prices":"no_data"} : Map.from(json["mgn:prices"]).map((k, v) => MapEntry<String, String>(k, v)), //todo: map fonction to have key: horaire, value: price ?
      // price30Min: json["price30Min"] == null ? null : json["price30Min"],
      // price60Min: json["price60Min"] == null ? null : json["price60Min"],
      // price120Min: json["price120Min"] == null ? null : json["price120Min"],
      // price240Min: json["price240Min"] == null ? null : json["price240Min"],

      //* For test purposes only
      // osmId: json["osm.id"] == null ? null : json["osm.id"].toString(),
      // osmType: json["osm.type"],

      // //* On récupère la partie dynamique, ce qui permet d'initialiser correctement les attributs une première fois
      // //* pour éviter des problème de cast
      // capacity: json["capacity"] == null ? null : json["capacity"],
      // available: json["mgn:available"] == null ? null : json["mgn:available"],
      // isClosed: json["mgn:closed"] == null ? null : json["mgn:closed"],
      // colorHexa: json["ui:color"] == null ? null : json["ui:color"],
      // colorText: json["ui:color_en"] == null ? null : json["ui:color_en"],
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

  // Conversion de JSON depuis la database local en objet Parking.
  factory Parking.fromDBJson(Map<String, dynamic> json) {
        return Parking(
      // osmId: json["osmId"] == null ? null : json["osmId"],
      id: json["_id"],
      name: json["name"],
      coordinates: List<double>.from(
          jsonDecode(json["coordinates"]).map((x) => x.toDouble())),
    
      addressNumber: json["addressNumber"],
      addressStreet: json["addressStreet"],
      address: json["address"],
      phone: json["phone"],
      website: json["website"],

      disabled: json["disabled"],
      charging: json["charging"],
      maxHeight: json["maxHeight"],
      type: json["type"],
      operator: json["operator"],

      fee: json["fee"],
      // prices: json["prices"] == null ? null : Map<String, String>.from(
      //   jsonDecode(json["prices"]).map((x) => x.toString())),
      // prices: json["prices"] == null ? null : Map.from(json["prices"]).map((k, v) => MapEntry<String, String>(k, v)),
      prices: json["prices"] == null ? null : Map.from(jsonDecode(json["prices"]).map((k, v) => MapEntry<String, String>(k, v))),
      zone: json["zone"],

      //* For test purposes only
      osmId: json["osmId"],
      osmType: json["osmType"],

    );
  }

  // Convertir en Json pour la database local
  Map<String, Object?> toJson() => {
    ParkingFields.id: id,
    ParkingFields.name: name,
    ParkingFields.coordinates: jsonEncode(coordinates),

    ParkingFields.addressNumber: addressNumber,
    ParkingFields.addressStreet: addressStreet,
    ParkingFields.address: address,
    ParkingFields.phone : phone,
    ParkingFields.website: website,

    ParkingFields.disabled: disabled,
    ParkingFields.charging: charging,
    ParkingFields.maxHeight: maxHeight,
    ParkingFields.type: type,
    ParkingFields.operator: operator,

    ParkingFields.fee: fee,
    ParkingFields.prices: jsonEncode(prices),
    ParkingFields.zone: zone,

    ParkingFields.osmId: osmId,
    ParkingFields.osmType: osmType
  };


}
  