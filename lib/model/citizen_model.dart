class Citizen {
  final String fullName;
  final String address;
  final String citizenReference;
  final String familyReference;
  final String locationReference;
  final String nic;
  final String contactNumber;
  final String landline;
  final String bloodGroup;
  final String passport;
  final String elderNumber;
  final String dob;
  final String gender;
  final String nationality;
  final String civilStatus;
  final String religion;

  Citizen({
    required this.fullName,
    required this.address,
    required this.citizenReference,
    required this.familyReference,
    required this.locationReference,
    required this.nic,
    required this.contactNumber,
    required this.landline,
    required this.bloodGroup,
    required this.passport,
    required this.elderNumber,
    required this.dob,
    required this.gender,
    required this.nationality,
    required this.civilStatus,
    required this.religion,
  });

  factory Citizen.fromJson(Map<String, dynamic> json) {
    return Citizen(
      fullName: json['fullName'] ?? '',
      address: json['address'] ?? '',
      citizenReference: json['citizenReference'] ?? '',
      familyReference: json['familyReference'] ?? '',
      locationReference: json['locationReference'] ?? '',
      nic: json['nic'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      landline: json['landline'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      passport: json['passport'] ?? '',
      elderNumber: json['elderNumber'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      nationality: json['nationality'] ?? '',
      civilStatus: json['civilStatus'] ?? '',
      religion: json['religion'] ?? '',
    );
  }
}
