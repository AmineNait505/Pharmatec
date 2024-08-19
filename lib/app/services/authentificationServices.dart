import 'package:ntlm/ntlm.dart';
import 'package:pharmatec/utils/constants.dart';
import 'dart:convert';

class AccountInactiveException implements Exception {
  final String message;
  AccountInactiveException(this.message);
}

class InvalidUsernameException implements Exception {
  final String message;
  InvalidUsernameException(this.message);
}

class InvalidPasswordException implements Exception {
  final String message;
  InvalidPasswordException(this.message);
}

class AuthentificationServices {

  Future<int> login(String serviceUsername, String servicePassword) async {
    const String url = "$Odatav4/TICOP_Login?Company=%27PHARMA-TEC%27";
    NTLMClient client = NTLMClient(
      domain: ntlmDomain,
      username: ntlmUsername,
      password: ntlmPassword,
    );
    var body = jsonEncode({
      'salespersoncode': serviceUsername,
      'salespersonpsw': servicePassword,
    });

    final response = await client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      int value = jsonResponse['value'];

      if (value == 1) {
        return value; // Success
      } else if (value == -1) {
        throw AccountInactiveException("Votre compte est inactif.");
      } else if (value == -2) {
        throw InvalidUsernameException("Sales Person invalide.");
      } else if (value == 0) {
        throw InvalidPasswordException("Mot de passe invalide.");
      } else {
        throw Exception("Erreur inconnue: $value");
      }
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }
}
