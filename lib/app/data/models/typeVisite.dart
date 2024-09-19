List<TypeVisite> actionsFromJson(dynamic str) =>
    List<TypeVisite>.from(str.map((x) => TypeVisite.fromJson(x)));

class TypeVisite {
  final String type;
  final String action;
  final String description;

  TypeVisite({
    required this.type,
    required this.action,
    required this.description,
  });

  factory TypeVisite.fromJson(Map<String, dynamic> json) {
    return TypeVisite(
      type: json['type'] ?? '',
      action: json['action'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "action": action,
        "description": description,
      };
}
