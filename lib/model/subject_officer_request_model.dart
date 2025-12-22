class SubjectOfficerRequest {
  final String? reference;
  final String? created;
  final String? citizen;
  final String? assignType;
  final String? assignTo;
  final String? assignedDate;
  final String? serviceStatus;
  final int? id;

  SubjectOfficerRequest({
    this.reference,
    this.created,
    this.citizen,
    this.assignType,
    this.assignTo,
    this.assignedDate,
    this.serviceStatus,
    this.id,
  });

  factory SubjectOfficerRequest.fromJson(Map<String, dynamic> json) {
    return SubjectOfficerRequest(
      reference: json['reference']?.toString(),
      created: json['created']?.toString(),
      citizen: json['citizen']?.toString(),
      assignType: json['assignType']?.toString(),
      assignTo: json['assignTo']?.toString(),
      assignedDate: json['assignedDate']?.toString(),
      serviceStatus: json['serviceStatus']?.toString(),
      id: json['id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'created': created,
      'citizen': citizen,
      'assignType': assignType,
      'assignTo': assignTo,
      'assignedDate': assignedDate,
      'serviceStatus': serviceStatus,
      'id': id,
    };
  }
}
