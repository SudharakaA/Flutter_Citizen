class Sdggoal {
  final String id;
  final String name;

  Sdggoal({
    required this.id,
    required this.name,
  });

  factory Sdggoal.fromJson(Map<String, dynamic> json) {
    return Sdggoal(
      id: json['SDG_GOAL_ID'],
      name: json['SDG_GOAL'],
    );
  }
}