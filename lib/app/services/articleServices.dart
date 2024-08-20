import 'dart:convert';

import 'package:ntlm/ntlm.dart';
import 'package:pharmatec/app/data/models/item.dart';
import 'package:pharmatec/utils/constants.dart';

class ArticelServices{

Future<List<Item>> fetchArticlebyCategories(String categoriesCode) async {
      final url = Uri.parse(
        "http://172.16.8.196:7048/BC240/api/OrderLine_Pharmatec/Order/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/Items?\$filter=ItemCategoryCode eq '$categoriesCode'"
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
          return itemsFromJson(clientsJson);
        } else {
          throw Exception('Failed to load articles');
        }
      } catch (e) {
        print('Error: $e');
        throw Exception('Failed to load articles');
      }
    }
Future<List<Item>> fetchArticlebyNO(String No) async {
      final url = Uri.parse(
        "http://172.16.8.196:7048/BC240/api/OrderLine_Pharmatec/Order/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/Items?\$filter=No eq '$No*'"
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
          return itemsFromJson(clientsJson);
        } else {
          throw Exception('Failed to load articles');
        }
      } catch (e) {
        print('Error: $e');
        throw Exception('Failed to load articles');
      }
    }

}