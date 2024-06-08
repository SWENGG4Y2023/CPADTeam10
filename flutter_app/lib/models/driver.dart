class Driver {
  final int? id;
  final String licenseNumber;
  final String mobileNumber;
  final String name;

  const Driver({
    this.id,
    required this.licenseNumber,
    required this.mobileNumber,
    required this.name,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      licenseNumber: json['licenseNumber'],
      mobileNumber: json['mobileNumber'],
      name: json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "licenseNumber": licenseNumber,
      "mobileNumber": mobileNumber,
      "name": name
    };
  }
}
