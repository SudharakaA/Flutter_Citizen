class Gnoffice {
  final String id;
  final String name;

  Gnoffice({
    required this.id,
    required this.name,
  });

  factory Gnoffice.fromJson(Map<String, dynamic> json) {
    return Gnoffice(
      id: json['GN_DIVISION_ID'],
      name: json['LOCATION'],
    );
  }
}
