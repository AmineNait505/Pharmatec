import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/commande.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import 'package:pharmatec/app/services/commandeServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommandesController extends GetxController {
  var isLoading = false.obs;

  // Separate lists for each document type
  var commandesOrder = <Commande>[].obs;
  var commandesBlanketOrder = <Commande>[].obs;
  var commandesQuote = <Commande>[].obs;

  // Separate filtered lists for each document type
  var filteredCommandesOrder = <Commande>[].obs;
  var filteredCommandesBlanketOrder = <Commande>[].obs;
  var filteredCommandesQuote = <Commande>[].obs;

  var errorMessage = ''.obs;

  final CommandeServices commandeServices = CommandeServices();
  final clientName = ''.obs;
  final contactId = ''.obs;
  var isMenuOpen = false.obs;

  var documentType = 'Order'.obs;  // Set default value to 'Order'

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadClientData();
    });
  }

  Future<void> fetchCommandes(String clientNumber, String contactNo, String documentType) async {
    if (clientNumber.isEmpty) return;
    isLoading.value = true;
    try {
      final fetchedCommandes = await commandeServices.fetchClients(clientNumber, contactNo, documentType);

      if (documentType == 'Order') {
        commandesOrder.assignAll(fetchedCommandes);
        filteredCommandesOrder.assignAll(fetchedCommandes);  
      } else if (documentType == 'Blanket Order') {
        commandesBlanketOrder.assignAll(fetchedCommandes);
        filteredCommandesBlanketOrder.assignAll(fetchedCommandes);
      } else if (documentType == 'Quote') {
        commandesQuote.assignAll(fetchedCommandes);
        filteredCommandesQuote.assignAll(fetchedCommandes);
      }

    } catch (e) {
      errorMessage.value = 'Failed to fetch commandes: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Search function that applies to the currently selected document type
  void searchCommandes(String query) {
    if (documentType.value == 'Order') {
      filteredCommandesOrder.value = _searchCommandesInList(query, commandesOrder);
    } else if (documentType.value == 'Blanket Order') {
      filteredCommandesBlanketOrder.value = _searchCommandesInList(query, commandesBlanketOrder);
    } else if (documentType.value == 'Quote') {
      filteredCommandesQuote.value = _searchCommandesInList(query, commandesQuote);
    }
  }

  // Helper method for searching in a specific list
  List<Commande> _searchCommandesInList(String query, List<Commande> commandes) {
    if (query.isEmpty) {
      return commandes;
    } else {
      return commandes.where((commande) {
        final idMatch = commande.id.toLowerCase().contains(query.toLowerCase());
        final dateMatch = commande.date.toLowerCase().contains(query.toLowerCase());
        return idMatch || dateMatch;
      }).toList();
    }
  }

  Future<void> loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    clientName.value = prefs.getString('client_business_relation') ?? '';
    contactId.value = prefs.getString('contact_id') ?? '';

    if (clientName.isNotEmpty || contactId.isNotEmpty) {
      // Fetch commandes with the default document type 'Order'
      await fetchCommandes(clientName.value, contactId.value, documentType.value);
    }
  }

  Future<void> saveCommandeAndNavigate(String commandeNo, String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_commande_no', commandeNo);
    await prefs.setString('commandeStatus', status);
    Get.toNamed(Routes.DETAILS);
  }
}
