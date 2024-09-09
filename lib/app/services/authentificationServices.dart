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
  Future<String> login(String serviceUsername, String servicePassword) async {
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
      
      // Check the type of the 'value' field
      var value = jsonResponse['value'];
      if (value is int) {
        switch (value) {
          case 1:
            return "Success"; // Indicate successful login
          case -1:
            throw AccountInactiveException("Votre compte est inactif.");
          case -2:
            throw InvalidUsernameException("Sales Person invalide.");
          case 0:
            throw InvalidPasswordException("Mot de passe invalide.");
          default:
            throw Exception("Erreur inconnue: $value");
        }
      } else if (value is String) {
        return value; // Return the string value directly if successful
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }
}
