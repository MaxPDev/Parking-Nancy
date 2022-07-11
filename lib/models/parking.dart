import 'dart:convert';

final String tableParkings = "parkings";

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

    fee,
    prices
  ];

  // static final String osmId = "osmId";
  static final String id = "_id";
  static final String name = "name";
  static final String coordinates = "coordinates";

  static final String addressNumber = "addresseNumber";
  static final String addressStreet = "addressStreet";
  static final String address = "address";
  static final String phone = "phone";
  static final String website = "website";

  static final String disabled = "disabled";
  static final String charging = "charging";
  static final String maxHeight = "maxHeight";
  static final String type = "type";
  static final String operator = "operator";

  static final String fee = "fee";
  static final String prices = "prices";



  // static final String capacity = "capacity";
}

//TODO: comment
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
      address: json["mgn:address"] == null ? null : json["mgn:address"],
      phone: json["contact:phone"] == null ? null : json["contact:phone"],
      website: json["website"] == null ? null : json["website"],

      disabled: json["capacity:disabled"] == null ? null : json["capacity:disabled"],
      charging: json["capacity:charging"] == null ? null : json["capacity:charging"],
      maxHeight: json["maxheight"] == null ? null : json["maxheight"],
      type: json["parking"] == null ? null : json["parking"],
      operator: json["operator"] == null ? null : json["operator"],

      fee: json["fee"] == null ? null : json["fee"],
      prices: json["mgn:prices"] == null ? {"prices":"no_data"} : Map.from(json["mgn:prices"]).map((k, v) => MapEntry<String, String>(k, v)), //todo: map fonction to have key: horaire, value: price ?
      // price30Min: json["price30Min"] == null ? null : json["price30Min"],
      // price60Min: json["price60Min"] == null ? null : json["price60Min"],
      // price120Min: json["price120Min"] == null ? null : json["price120Min"],
      // price240Min: json["price240Min"] == null ? null : json["price240Min"],

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
      id: json["_id"] == null ? null : json["_id"],
      name: json["name"] == null ? null : json["name"],
      coordinates: List<double>.from(
          jsonDecode(json["coordinates"]).map((x) => x.toDouble())),
    
      addressNumber: json["addressNumber"] == null ? null : json["addressNumber"],
      addressStreet: json["addressStreet"] == null ? null : json["addressStreet"],
      address: json["address"] == null ? null : json["address"],
      phone: json["phone"] == null ? null : json["phone"],
      website: json["website"] == null ? null : json["website"],

      disabled: json["disabled"] == null ? null : json["disabled"],
      charging: json["charging"] == null ? null : json["charging"],
      maxHeight: json["maxHeight"] == null ? null : json["maxHeight"],
      type: json["type"] == null ? null : json["type"],
      operator: json["operator"] == null ? null : json["operator"],

      fee: json["fee"] == null ? null : json["fee"],
      // prices: json["prices"] == null ? null : Map<String, String>.from(
      //   jsonDecode(json["prices"]).map((x) => x.toString())),
      // prices: json["prices"] == null ? null : Map.from(json["prices"]).map((k, v) => MapEntry<String, String>(k, v)),
      prices: json["prices"] == null ? null : Map.from(jsonDecode(json["prices"]).map((k, v) => MapEntry<String, String>(k, v))),

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
  };


}
  