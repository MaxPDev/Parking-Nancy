//?AddressFields si conservation da,s BD ? Genre sauvegard adresse, ou stationnement

class Address {
  final String id;
  final String label;
  final List<double> coordinates;

  final String? name;
  final String? housenumber;
  final String? street;
  final String? postcode;
  final String? city;

  final double? distance;

  Address({
    required this.id,
    required this.label,
    required this.coordinates,

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
    List<double>? coordinates,

    String? name,
    String? housenumber,
    String? street,
    String? postcode,
    String? city,

    double? distance,

  }) => Address(
    id: id ?? this.id,
    label: label ?? this.label,
    coordinates: coordinates ?? this.coordinates,

    name: name ?? this.name,
    housenumber: housenumber ?? this.housenumber,
    street: street ?? this.street,
    postcode: postcode ?? this.postcode,
    city: city ?? this.city,

    distance: distance ?? this.distance,
  );

  factory Address.fromAPIJson(Map<String, dynamic>json) {
    return Address(
      id: json["id"] == null ? null : json["id"],
      label: json["label"] == null ? null : json["label"],
      coordinates: List<double>.from(
          json["geometry.coordinates"].map((x) => x.toDouble()))

  }

}