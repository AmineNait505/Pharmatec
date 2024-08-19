List<Client> clientsFromJson(dynamic str) =>
    List<Client>.from(str.map((x) => Client.fromJson(x)));

class Client {
  final String id;
  final String nom;


  Client({required this.id,  required this.nom});
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['No'],
      nom: json['Name']);
  }
  Map<String, dynamic> toJson() => {
        "No": id,
        "Name": nom,
      
      };
  int get hashcode => Object.hash(id, nom);
}