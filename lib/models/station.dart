class Station {

  // Données statiques
  final int id;
  // final String contractName;
  final String name;
  final String address;
  // final List<double> position;
  final double long;
  final double lat;
  final String status;
  final bool banking;

  // Données dynamiques
  int? bikes;
  int? stands;

  Station({
    required this.id,
    // required this.contractName,
    required this.name,
    required this.address,
    // required this.position,
    required this.long,
    required this.lat,
    required this. status,
    required this.banking,
    this.bikes,
    this.stands,
  });

  Station copyWith({

    // Données statiques
    int? id,
    // String contractName,
    String? name,
    String? address,
    // List<double>? position,
    double? long,
    double? lat,
    String? status,
    bool? banking,

    // Données dynamiques
    int? bikes,
    int? stands,

  }) => Station(

    id: id ?? this.id,
    // contractName: contractName ?? this.contractName,
    name: name ?? this.name,
    address: address ?? this.address,
    // position: position ?? this.position,
    long: long ?? this.long,
    lat: lat ?? this.lat,
    status: status ?? this.status,
    banking: banking ?? this.banking,

    bikes: bikes ?? this.bikes,
    stands: stands ?? this.stands,

  );

  factory Station.fromAPIJson(Map<String, dynamic> json) {
    return Station(
      id: json["number"], 
      name: json["name"], 
      address: json["address"], 
      // position: List<double>.from(json["position"].map(x)), 
      long: json["position"]["longitude"],
      lat: json["position"]["latitude"],
      status: json["status"], 
      banking: json["banking"],
    );
  }

}