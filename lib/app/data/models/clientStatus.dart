
List<ClientStatus> clientStatusFromJson(dynamic str) =>
    List<ClientStatus>.from(str.map((x) => ClientStatus.fromJson(x)));

class ClientStatus {
  final double solde;
  final double soldeEchu;
  final double payementEnCours;
  final double commandeEnCours;
  final double restant;
  final String? cause_blocage;

  ClientStatus({
    required this.solde,
    required this.soldeEchu,
    required this.payementEnCours,
    required this.commandeEnCours,
    required this.restant,
     this.cause_blocage
  });

  factory ClientStatus.fromJson(Map<String, dynamic> json) {
    return ClientStatus(
      solde: json['Solde']?.toDouble() ?? 0.0,
      soldeEchu: json['SoldeEchu']?.toDouble() ?? 0.0,
      payementEnCours: json['PayementEnCours']?.toDouble() ?? 0.0,
      commandeEnCours: json['CommandeEnCours']?.toDouble() ?? 0.0,
      restant: json['Restant']?.toDouble() ?? 0.0,
      cause_blocage: json['CauseDuBlocage'] ?? ''
    );
  }

  Map<String, dynamic> toJson() => {
        "Solde": solde,
        "SoldeEchu": soldeEchu,
        "PayementEnCours": payementEnCours,
        "CommandeEnCours": commandeEnCours,
        "Restant": restant,
      };
}
