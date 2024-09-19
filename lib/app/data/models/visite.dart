class Visite {
  final int visiteNo;
  final String type;
  final String action;
  final String canal;
  final String clientNo;
  final String clientName;
  final String commercialNo;
  final String contactNo;
  final String contactName;
  final String dateVisite;
  final String document;
  final String feedback;
  final String notes;
  final String status;

  Visite({
    required this.visiteNo,
    required this.type,
    required this.action,
    required this.canal,
    required this.clientNo,
    required this.commercialNo,
    required this.contactNo,
    required this.dateVisite,
    required this.document,
    required this.feedback,
    required this.notes,
    required this.status,
    required this.clientName,
    required this.contactName

  });
  factory Visite.fromJson(Map<String, dynamic> json) {
    return Visite(
      visiteNo: json['visiteNo'],
      type: json['type'],
      action: json['action'],
      canal: json['canal'],
      clientNo: json['clientNo'],
      commercialNo: json['commercialNo'],
      contactNo: json['contactNo'],
      dateVisite: json['dateVisite'],
      document: json['document'],
      feedback: json['feedback'],
      notes: json['notes'],
      status: json['status'],
      clientName: json['ClientName'],
      contactName: json['ContactName']
    );
  }
  Map<String, dynamic> toJson() => {
        "visiteNo": visiteNo,
        "type": type,
        "action": action,
        "canal": canal,
        "clientNo": clientNo,
        "commercialNo": commercialNo,
        "contactNo": contactNo,
        "dateVisite": dateVisite,
        "document": document,
        "feedback": feedback,
        "notes": notes,
        "status": status,
      };

  
  static List<Visite> visitesFromJson(dynamic str) =>
      List<Visite>.from(str.map((x) => Visite.fromJson(x)));
}
