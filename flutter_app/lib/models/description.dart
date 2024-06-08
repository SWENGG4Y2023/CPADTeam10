class Description {
  final int? id;
  final String name;
  final String packet;
  final String type;
  final String? weight;

  const Description(
      {required this.id,
      required this.name,
      required this.packet,
      required this.type,
      required this.weight});

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
        id: json['id'],
        name: json['name'],
        packet: json['packet'],
        type: json["type"],
        weight: json['weight']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "packet": packet,
      "type": type,
      "weight": weight,
    };
  }
}
