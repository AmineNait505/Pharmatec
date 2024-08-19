import 'dart:convert';
import 'package:ntlm/ntlm.dart';
import 'package:pharmatec/app/data/models/commande.dart';
import 'package:pharmatec/utils/constants.dart';

class CommandeServices {
  Future<List<Commande>> fetchClients(String clientNumber) async {
    final url = Uri.parse(
      "http://172.16.8.195:7048/BC240/api/Commande_Pharmatec/commande/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/commandes?\$filter=Sell_to_Customer_No eq '$clientNumber'"
    );
    final client = NTLMClient(
      username: ntlmUsername,
      password: ntlmPassword,
      domain: ntlmDomain,
    );

    try {
      final response = await client.get(url);
      print(response.body);
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> clientsJson = data['value'];
        return commandesFromJson(clientsJson);
      } else {
        throw Exception('Failed to load commandes');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load commandes');
    }
  }
}
