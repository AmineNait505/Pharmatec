import 'dart:convert';

import 'package:ntlm/ntlm.dart';
import 'package:pharmatec/app/data/models/categories.dart';

import 'package:pharmatec/utils/constants.dart';

class CategorieServices{
  Future<List<Categorie>> fetchClients() async {
    final url = Uri.parse('http://172.16.8.199:7048/BC240/api/OrderLine_Pharmatec/Order/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/ItemCategories');
    final client = NTLMClient(username: ntlmUsername, password: ntlmPassword,domain: ntlmDomain);

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> clientsJson = data['value'];
        return categoriesFromJson(clientsJson);
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load categories');
    }
  }
  
}