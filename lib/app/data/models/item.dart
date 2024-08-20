List<Item> itemsFromJson(dynamic str) =>
    List<Item>.from(str.map((x) => Item.fromJson(x)));

class Item {
  final String id;
  final String nom;
  final int qte;
  final int price;


  Item({required this.id,  required this.nom,required this.qte ,required this.price});
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['No'],
      nom: json['Description'],
      qte:json['Inventory'],
      price: json['UnitPrice']);
  }
  Map<String, dynamic> toJson() => {
        "No": id,
        "Name": nom,
      
      };
  int get hashcode => Object.hash(id, nom);
}