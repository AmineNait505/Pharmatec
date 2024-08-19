List<Commande> commandesFromJson(dynamic str) =>
    List<Commande>.from(str.map((x) => Commande.fromJson(x)));

class Commande {
  final String id;
  final String date;
  final String documentType;
  final String status;
  final double price;

  Commande({required this.id,required this.date,required this.documentType,required this.status,required this.price});
  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      id: json['No'],
      date:  json['Posting_Date'],
      documentType: json['Document_Type'],
      status:json['Status'],
      price: (json['Amount_Including_VAT'] as num).toDouble(),
      );
  }
  Map<String, dynamic> toJson() => {
        "No": id,
        "Posting_Date":date,
        "Document_Type":documentType,
        "Status":status,
        "Amount_Including_VAT":price
      
      };
  int get hashcode => Object.hash(id,date);
}