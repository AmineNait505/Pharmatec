List<Article> articlesFromJson(dynamic str) =>
    List<Article>.from(str.map((x) => Article.fromJson(x)));

class Article {
  final String id;
  final String description;
  final String qte;
  final int price;
  final int remise;

  Article({
    required this.id,
    required this.description,
    required this.qte,
    required this.price,
    required this.remise
    });
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['No'],
      description: json['Description'],
      qte:json['Quantity'],
      price :json['Unit_Price'],
      remise: json['Remise']
      );
  }
  Map<String, dynamic> toJson() => {
        "No": id,
        "Description":description,
        "Quantity":qte,
        "Unit_Price":price,
        "Remise":remise,
        "Amount_Including_VAT":price
      };
  int get hashcode => Object.hash(id,description,qte,price,remise);
}