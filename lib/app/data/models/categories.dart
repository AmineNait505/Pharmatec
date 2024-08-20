List<Categorie> categoriesFromJson(dynamic str) =>
    List<Categorie>.from(str.map((x) => Categorie.fromJson(x)));

class Categorie {
  final String id;
  final String description;
  

  Categorie({required this.id,required this.description});
  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['Code'],
      description:  json['Description'],
    
      );
  }
  Map<String, dynamic> toJson() => {
        "Code": id,
        "Description":description,
      
      };
  int get hashcode => Object.hash(id,description);
}