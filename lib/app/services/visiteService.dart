import 'dart:convert';
import 'dart:io';
import 'package:ntlm/ntlm.dart';
import 'package:pharmatec/app/data/models/typeVisite.dart';
import 'package:pharmatec/app/data/models/visite.dart';
import 'package:pharmatec/utils/constants.dart';

class VisiteService {

  Future<List<Visite>> fetchVisites(String commercialNo, String contactNo) async {
    final url = Uri.parse(
        "http://172.16.8.199:7048/BC240/api/Visite_Pharmatec/Visite/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/Visites?\$filter=commercialNo eq '$commercialNo' and contactNo eq '$contactNo**'");

    final client = NTLMClient(
      username: ntlmUsername,
      password: ntlmPassword,
      domain: ntlmDomain,
    );

    try {
      final response = await client.get(url);
      print("calendar ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> visitesJson = data['value'];
        return Visite.visitesFromJson(visitesJson);
      } else {
        throw Exception('Failed to load visites');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load visites');
    }
  }
   Future<List<TypeVisite>> fetchActions() async {
    final url = Uri.parse(
        "http://172.16.8.199:7048/BC240/api/Action_Par_Type_Pharmatec/ActionParType/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/Actions");

    final client = NTLMClient(
      username: ntlmUsername,
      password: ntlmPassword,
      domain: ntlmDomain,
    );

    try {
      final response = await client.get(url);
      print("action type ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> actionsJson = data['value'];
        return actionsFromJson(actionsJson);
      } else {
        throw Exception('Failed to load actions');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load actions');
    }
  }
   Future<int> createVisite({
    required String type,
    required String action,
    required String commercialNo,
    required String contactNo,
    required String dateVisite,
  }) async {
    final url = Uri.parse(
        "http://172.16.8.199:7048/BC240/api/Visite_Pharmatec/Visite/v2.0/companies(05bb55d8-f023-ef11-87e9-000c29ee52bb)/Visites");

    final client = NTLMClient(
      username: ntlmUsername,
      password: ntlmPassword,
      domain: ntlmDomain,
    );

    final Map<String, dynamic> visiteData = {
      "type": type,
      "action": action,
      "commercialNo": commercialNo,
      "contactNo": contactNo,
      "dateVisite": dateVisite,
    };

    try {
      final response = await client.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(visiteData),
      );
 print('Erreur API : $visiteData');
      if (response.statusCode == 201) {
      
        return 1;
      } else {
        final errorData = jsonDecode(response.body);
        if (errorData.containsKey("error")) {
          final errorCode = errorData["error"]["code"];
          final errorMessage = errorData["error"]["message"];
          print('Erreur API : $errorCode - $errorMessage');
          throw Exception('Erreur API : $errorCode - $errorMessage');
        } else {
          throw Exception('Erreur inattendue : ${response.body}');
        }
      }
    } on SocketException {
      // Gérer les erreurs liées au réseau
      print('Problème de connexion : Impossible de se connecter au serveur');
      throw Exception('Problème de connexion : Impossible de se connecter au serveur');
    } catch (e) {
      // Attraper d'autres exceptions
      print('Erreur : $e');
      throw Exception('Échec de la création de la visite : $e');
    }
  }
}
