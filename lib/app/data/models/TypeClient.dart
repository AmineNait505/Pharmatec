List<TypeClient> typeClientsFromJson(List<dynamic> json) {
  return json.map((typeClient) => TypeClient.fromJson(typeClient)).toList();
}

class TypeClient {
  final String id;
  final String name;

  TypeClient({required this.id, required this.name});

  factory TypeClient.fromJson(Map<String, dynamic> json) {
    return TypeClient(
      id: json['Code'],
      name: json['Description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Code': id,
      'Description': name,
    };
  }
}