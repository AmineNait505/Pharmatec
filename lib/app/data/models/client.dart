// ignore: non_constant_identifier_names
List<Client> clientsFromJson(dynamic str) =>
    List<Client>.from(str.map((x) => Client.fromJson(x)));

class Client {
  final String id;
  final String nom;
  final int NbrContact;
  List<Client>? contacts;
  final String business_relation;


  // ignore: non_constant_identifier_names
  Client({required this.id,  required this.nom, required this.NbrContact,this.contacts,required this.business_relation});
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['no'],
      nom: json['Name'],
      NbrContact: json['Nbre_Personnes'],
      business_relation: json['Contact_Business_Relation']);
  }
  Map<String, dynamic> toJson() => {
        "no": id,
        "Name": nom,
        "Nbre_Personnes":NbrContact,
        'Contact_Business_Relation':business_relation
      
      };
  int get hashcode => Object.hash(id, nom);
}