//?AddressFields si conservation da,s BD ? Genre sauvegard adresse, ou stationnement

class Address {
  final String? id;
  final String? label;
  // final List<double> coordinates;
  final double long;
  final double lat;

  final String? name;
  final String? housenumber;
  final String? street;
  final String? postcode;
  final String? city;

  final int? distance;

  Address({
    this.id,
    this.label,
    // required this.coordinates,
    required this.long,
    required this.lat,

    this.name,
    this.housenumber,
    this.street,
    this.postcode,
    this.city,
    this.distance,
  });

  Address copyWith({
    String? id,
    String? label,
    // List<double>? coordinates,
    double? long,
    double? lat,

    String? name,
    String? housenumber,
    String? street,
    String? postcode,
    String? city,
    int? distance,
  }) =>
      Address(
        id: id ?? this.id,
        label: label ?? this.label,
        // coordinates: coordinates ?? this.coordinates,
        long: long ?? this.long,
        lat: lat ?? this.lat,

        name: name ?? this.name,
        housenumber: housenumber ?? this.housenumber,
        street: street ?? this.street,
        postcode: postcode ?? this.postcode,
        city: city ?? this.city,
        distance: distance ?? this.distance,
      );

  factory Address.fromAPIJson(Map<String, dynamic> json) {
    return Address(
      id: json["properties"]["id"],
      label: json["properties"]["label"],
      // coordinates: List<double>.from(
      //     json["geometry.coordinates"].map((x) => x.toDouble())),
      long: json['geometry']['coordinates'][0],
      lat: json['geometry']['coordinates'][1],

      name: json["properties"]["name"],
      housenumber: json["properties"]["housenumber"],
      street: json["properties"]["street"],
      postcode: json["properties"]["postcode"],
      city: json["properties"]["city"],
      distance: json["properties"]["distance"],
    );
  }
}
