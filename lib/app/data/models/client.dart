List<Client> clientsFromJson(dynamic str) =>
    List<Client>.from(str.map((x) => Client.fromJson(x)));

class Client {
  final String id;
  final String nom;
  final int NbrContact;
  List<Client>? contacts;


  Client({required this.id,  required this.nom, required this.NbrContact,this.contacts,});
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['no'],
      nom: json['Name'],
      NbrContact: json['Nbre_Personnes']);
  }
  Map<String, dynamic> toJson() => {
        "no": id,
        "Name": nom,
        "Nbre_Personnes":NbrContact
      
      };
  int get hashcode => Object.hash(id, nom);
}