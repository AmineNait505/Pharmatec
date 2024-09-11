import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import 'package:pharmatec/app/services/authentificationServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var obscureText = true.obs;
  var isLoading = false.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var emailFocusNode = FocusNode(); // Focus node for the email field
  var passwordFocusNode = FocusNode(); // Focus node for the password field

  AuthentificationServices authService = AuthentificationServices();

  void onEmailChanged(String value) {
    email.value = value;
    emailError.value = ''; // Clear error message when user starts typing
  }

  void onPasswordChanged(String value) {
    password.value = value;
    passwordError.value = ''; // Clear error message when user starts typing
  }

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }
   Future<void> _saveSalespersonInfo(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('salesperson', email);
  }
  Future<void> _saveSecteurCode(String secteurCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('secteur_code', secteurCode);
}
  Future<void> onLoginPressed() async {
    isLoading.value = true;
    emailError.value = '';
    passwordError.value = '';

    try {
      Future.delayed(Duration(seconds: 3)); 
      String secteurCode = await authService.login(email.value, password.value);
      print(email.value);
      await _saveSalespersonInfo(email.value);
      print("Secteur $secteurCode");
      await _saveSecteurCode(secteurCode);
      Get.snackbar('Succès', 'Connexion réussie !',
          backgroundColor: Colors.green, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,);
          Get.offNamed(Routes.CLIENTS);
    } on AccountInactiveException catch (e) {
      Get.snackbar('Erreur', e.message,
          backgroundColor: Colors.orange, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,);
    } on InvalidUsernameException catch (e) {
      emailError.value = e.message;
      emailFocusNode.requestFocus();
    } on InvalidPasswordException catch (e) {
      passwordError.value = e.message;
      passwordFocusNode.requestFocus();
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur inconnue s\'est produite.',
          backgroundColor: Colors.red, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,);
    } finally {
      isLoading.value = false;
    }
  }
}
