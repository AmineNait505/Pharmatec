import 'dart:convert';

import 'package:ntlm/ntlm.dart';
import 'package:pharmatec/app/data/models/client.dart';
import 'package:pharmatec/utils/constants.dart';

class ClientServices{
  Future<List<Client>> fetchClients() async {
    final url = Uri.parse('$apiv2(05bb55d8-f023-ef11-87e9-000c29ee52bb)/Customers');
    final client = NTLMClient(username: ntlmUsername, password: ntlmPassword,domain: ntlmDomain);

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> clientsJson = data['value'];
        return clientsFromJson(clientsJson);
      } else {
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load clients');
    }
  }
  
}