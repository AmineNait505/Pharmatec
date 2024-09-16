import 'dart:convert';

import 'package:ntlm/ntlm.dart';
import 'package:pharmatec/app/data/models/TypeClient.dart';
import 'package:pharmatec/app/data/models/client.dart';
import 'package:pharmatec/app/data/models/clientStatus.dart';
import 'package:pharmatec/utils/constants.dart';

class ClientServices{
  /*Future<List<Client>> fetchClients() async {
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
  }*/
  Future<List<TypeClient>> fetchTypeClients() async {
  final url = Uri.parse(
      '$apiv2/Contact_Pharmatec/Contact/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/TypeClientList');
  final client = NTLMClient(
      username: ntlmUsername, password: ntlmPassword, domain: ntlmDomain);

  try {
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> typeClientsJson = data['value'];
      return typeClientsFromJson(typeClientsJson);
    } else {
      throw Exception('Failed to load type clients');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to load type clients');
  }
}
  Future<List<Client>> fetchClientsByType(String typeClient, String territoryCode) async {
    final url = Uri.parse(
        '$apiv2/Contact_Pharmatec/Contact/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/ContactList?\$filter=Territory_Code eq \'$territoryCode\' and TypeClient eq \'$typeClient\' and type eq \'Company\'');
    final client = NTLMClient(
      username: ntlmUsername, password: ntlmPassword, domain: ntlmDomain);

    try {
      final response = await client.get(url);
       print('test ${response.body}');
      if (response.statusCode == 200) {
        print('test ${response.body}');
        final data = jsonDecode(response.body);
        print(data);
        final List<dynamic> clientsJson = data['value'];
        return clientsFromJson(clientsJson);
      } else {
        throw Exception('Failed to load clients by type');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load clients by type');
      
    }
  }
  Future<List<Client>> fetchClientContacts(String companyNo) async {
    final String url = "$apiv2/Contact_Pharmatec/Contact/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/ContactList?\$filter=Company_no eq '$companyNo' and type eq 'Person'";
     final client = NTLMClient(
      username: ntlmUsername, password: ntlmPassword, domain: ntlmDomain);

    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body)['value'];
      return clientsFromJson(jsonResponse);
    } else {
      throw Exception('Failed to fetch contacts');
    }
  }
    Future<List<ClientStatus>> fetchClientStatus(String clientId) async {
    final url = Uri.parse(
        '$apiv2/Pharma_tec/customer/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/Customers?\$filter=No eq \'$clientId\'');
       final client = NTLMClient(
      username: ntlmUsername, password: ntlmPassword, domain: ntlmDomain);

    try {

      final response = await client.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> statusJson = data['value'];
        return clientStatusFromJson(statusJson);
      } else {
        throw Exception('Failed to load client status');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load client status');
    }
  }
}


