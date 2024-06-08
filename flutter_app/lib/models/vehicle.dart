class Vehicle {
  final int? id;
  final String vehicleNumber;
  final String vehicleType;
  final bool? marketOrOwn;

  const Vehicle({
    this.id,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.marketOrOwn,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        id: json['id'],
        vehicleNumber: json['vehicleNumber'],
        vehicleType: json['vehicleType'],
        marketOrOwn: json['marketOrOwn']);
  }
  Map<String, dynamic> toJson() {
    return {
      "vehicleNumber": vehicleNumber,
      "vehicleType": vehicleType,
      "marketOrOwn": marketOrOwn
    };
  }
}
