class Sector {
  final String id;
  final String name;

  Sector({
    required this.id,
    required this.name,
  });

  factory Sector.fromJson(Map<String, dynamic> json) {
    return Sector(
      id: json['SECTOR_ID'],
      name: json['SECTOR_NAME'],
    );
  }
}