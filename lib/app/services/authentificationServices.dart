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

    // Handle success (status code 200)
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      var value = jsonResponse['value'];
      if (value is String) {
        if (value == "-2") {
          // Handle incorrect salesperson code
          throw InvalidUsernameException("Sales Person invalide.");
        } else {
          // Return the code on success
          return value; // e.g., "S01"
        }
      } else {
        throw Exception("Unexpected response format");
      }
    }
    // Handle incorrect password (status code 400)
    else if (response.statusCode == 400) {
      var errorResponse = jsonDecode(response.body);
      if (errorResponse['error'] != null && errorResponse['error']['message'] != null) {
        var errorMessage = errorResponse['error']['message'];
        if (errorMessage.contains("MP non valide")) {
          throw InvalidPasswordException("Mot de passe invalide.");
        }
      }
    }

    // Handle any other status codes or unexpected cases
    throw Exception('Failed to login: ${response.statusCode}');
  }
}
