class Project {
  final String id;
  final String category;
  final String type;
  final String location;
  final String description;
  final String? file;
  final String userName;
  final String friendlyName;
  final String citizenName;
  final String gnDivisionId;

  Project({
    required this.id,
    required this.category,
    required this.type,
    required this.location,
    required this.description,
    this.file,
    required this.userName,
    required this.friendlyName,
    required this.citizenName,
    required this.gnDivisionId,
  });
}