class Location {
  final String id;
  final String name;

  Location({
    required this.id,
    required this.name,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['DS_DIVISION_ID'],
      name: json['LOCATION'],
    );
  }
}