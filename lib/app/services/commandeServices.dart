import 'dart:convert';
import 'package:ntlm/ntlm.dart';
import 'package:pharmatec/app/data/models/article.dart';
import 'package:pharmatec/app/data/models/commande.dart';
import 'package:pharmatec/utils/constants.dart';

class CommandeServices {
  Future<List<Commande>> fetchClients(String clientNumber,String ContactNo) async {
    final url = Uri.parse(
      "http://172.16.8.199:7048/BC240/api/Commande_Pharmatec/commande/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/commandes?\$filter=Sell_to_Customer_No eq '$clientNumber' and contactNo eq '$ContactNo**'"
    );
    final client = NTLMClient(
      username: ntlmUsername,
      password: ntlmPassword,
      domain: ntlmDomain,
    );

    try {
      final response = await client.get(url);
      print(response.body);
      print('coomandde header ${response.body }');
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
    // ignore: non_constant_identifier_names
    Future<List<Article>> fetchLines(String DocumentNo) async {
      final url = Uri.parse(
        "http://172.16.8.199:7048/BC240/api/Ligne_Commande_Pharmatec/LigneCommande/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/lignescommande?\$filter=DocumentNo eq '$DocumentNo'"
      );
      final client = NTLMClient(
        username: ntlmUsername,
        password: ntlmPassword,
        domain: ntlmDomain,
      );

      try {
        final response = await client.get(url);
        print(response.body);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List<dynamic> clientsJson = data['value'];
          return articlesFromJson(clientsJson);
        } else {
          throw Exception('Failed to load articles');
        }
      } catch (e) {
        print('Error: $e');
        throw Exception('Failed to load articles');
      }
    }
    Future<String> createOrderLine({
  required String clientNo,
  required String itemNo,
  required String qty,
  required String salespersonCode,
  required String ContactNo,
  required int  remise
}) async {
  const url = '$apiv2/OrderLine_Pharmatec/Order/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/OrderLines';
  
  final body = jsonEncode({
    'clientNo': clientNo,
    'headerNo': "",
    'contactNo':ContactNo,
    'remise':remise,
    'itemNo': itemNo,
    'qty': qty,
    'salespersoncode': salespersonCode,
  });
  final client = NTLMClient(
        username: ntlmUsername,
        password: ntlmPassword,
        domain: ntlmDomain,
      );


  try {
    final response = await client.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );
    print(response.body);
 if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final headerNo = responseData['headerNo'] ?? 'Unknown headerNo';
      return headerNo;
    } else {
      final errorResponse = jsonDecode(response.body);
      final errorMessage = errorResponse['error']['message'] ?? 'Unknown error';
      return 'Error: $errorMessage';
    }
  } catch (e) {
    return 'Exception: ${e.toString()}';
  }
}
}
