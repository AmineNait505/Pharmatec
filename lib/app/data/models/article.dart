List<Article> articlesFromJson(dynamic str) =>
    List<Article>.from(str.map((x) => Article.fromJson(x)));

class Article {
  final String id;
  final String description;
  final int qte;
  final double price;
  final double remise;
  final double totalLine;

  Article({
    required this.id,
    required this.description,
    required this.qte,
    required this.price,
    required this.remise,
    required this.totalLine,
    });
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['No'],
      description: json['Description'],
      qte:json['Quantity'],
       price: (json['Unit_Price'] as num).toDouble(), // Convert int or double to double
      remise: (json['Remise'] as num).toDouble(), 
      totalLine: (json['Amount'] as num).toDouble(), 
      );
  }
  Map<String, dynamic> toJson() => {
        "No": id,
        "Description":description,
        "Quantity":qte,
        "Unit_Price":price,
        "Remise":remise,
        "Amount_Including_VAT":price,
        "Amount":totalLine
      };
  int get hashcode => Object.hash(id,description,qte,price,remise);
}