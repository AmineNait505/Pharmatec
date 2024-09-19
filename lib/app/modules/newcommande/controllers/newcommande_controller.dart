import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/item.dart';
import 'package:pharmatec/app/routes/app_pages.dart';

import 'package:pharmatec/app/services/commandeServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewcommandeController extends GetxController {
  var selectedArticles = <Item>[].obs; 
  var quantityErrors = <int, String?>{}.obs; 
  var discountErrors = <int, String?>{}.obs; 
  
  var enteredQuantities = <int, int>{}.obs; // Store entered quantities separately
  var enteredDiscounts = <int, int>{}.obs;  // Store entered discounts separately

  final salesPerson = ''.obs;
  final contactId = ''.obs;
  final clientBusinessRelation = ''.obs;
  final causeBlocage = ''.obs;
  final solde=0.0.obs;
  var isQuote = false.obs;
  var isIndirect = false.obs;
  var  total = 0.0.obs;

  final CommandeServices commandeServices = CommandeServices();

  @override
  void onInit() {
    super.onInit();
    loadSelectedArticles();
    
    // Initialize isQuote and isIndirect from Get.arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isQuote.value = Get.arguments['isQuote'] ?? false;
      isIndirect.value = Get.arguments['isIndirect'] ?? false;
      loadClientData();
    });
  }

  Future<void> loadSelectedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? articlesJson = prefs.getStringList('selected_articles');
    if (articlesJson != null) {
      selectedArticles.assignAll(articlesJson.map((json) => Item.fromJson(jsonDecode(json))).toList());
    }
  }

  Future<void> loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    salesPerson.value = prefs.getString('salesperson') ?? '';
    clientBusinessRelation.value = prefs.getString('client_business_relation') ?? 'Unknown';
    contactId.value = prefs.getString('contact_id') ?? ''; 
    causeBlocage.value=prefs.getString('cause_bloacage') ?? ' ';
    solde.value=prefs.getDouble('solde') ?? 0.0;
    print("solde ${solde.value}");
  }

  void validateQuantity(Item item, int newQuantity) {
    if (newQuantity > item.qte) {
      quantityErrors[item.hashCode] = 'La quantité dépasse le stock disponible';
    } else {
      quantityErrors[item.hashCode] = null;
      enteredQuantities[item.hashCode] = newQuantity; // Store the valid quantity
    }
  }

  void validateDiscount(Item item, int newDiscount) {
    if (newDiscount > 15) {
      discountErrors[item.hashCode] = 'La remise ne peut pas dépasser 15%';
    } else {
      discountErrors[item.hashCode] = null;
      enteredDiscounts[item.hashCode] = newDiscount; // Store the valid discount
    }
  }

  String? getQuantityError(Item item) {
    return quantityErrors[item.hashCode];
  }

  String? getDiscountError(Item item) {
    return discountErrors[item.hashCode];
  }

  double calculateTotalPrice() {
    total.value = 0.0;
  for (var article in selectedArticles) {
    int quantity = enteredQuantities[article.hashCode] ?? 0;
    double discount = (enteredDiscounts[article.hashCode] ?? 0) / 100;
    total.value += quantity * article.price * (1 - discount);
  }
  total.value *= 1.19;
  
  return total.value;
}

  Future<void> submitOrder() async {
    try {
      String? lastHeaderNo;
      String documentType;

      // Use isQuote and isIndirect from the controller
      if (isQuote.value) {
        documentType = 'Quote';
      } else if (isIndirect.value) {
        print("AMINE NAIT SLIMEN ${isIndirect.value}");
        for (var article in selectedArticles) {
          final result = await commandeServices.createCommandeIndirecte(
            noContact: contactId.value,
            noCommercial: salesPerson.value,
            noArticle: article.id,
            qty: enteredQuantities[article.hashCode]!,
          );

          if (result.startsWith('Error')) {
            Get.snackbar(
              'Erreur',
              'Une erreur s\'est produite lors de la création de la commande indirecte.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }

          Get.snackbar(
            'Succès',
            'La commande indirecte a été créée avec succès.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.offNamed(Routes.CALENDAR);
          return;
        }
        return;
      } else if(causeBlocage.value != 'Non bloqué' || total.value>=solde.value) {
        documentType = 'Blanket Order';
      }else{
        documentType = 'Order';
      }

      for (var article in selectedArticles) {
        final headerNo = await commandeServices.createOrderLine(
          documentType: documentType,
          clientNo: clientBusinessRelation.value,
          itemNo: article.id,
          qty: enteredQuantities[article.hashCode]!.toString(),
          salespersonCode: salesPerson.value,
          ContactNo: contactId.value,
          remise: enteredDiscounts[article.hashCode] ?? 0,
        );

        if (headerNo.startsWith('Error') || headerNo == 'Unknown headerNo') {
          Get.snackbar(
            'Erreur',
            'Une erreur s\'est produite lors de la création de la ligne de commande.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
        lastHeaderNo = headerNo;
      }

      if (lastHeaderNo != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_commande_no', lastHeaderNo);

        Get.snackbar(
          'Succès',
          isQuote.value
              ? 'Le devis a été créé avec succès.'
              : 'La commande a été créée avec succès.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offNamed(Routes.DETAILS);
      }

    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur s\'est produite: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
