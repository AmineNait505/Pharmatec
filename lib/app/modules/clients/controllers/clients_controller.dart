import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/client.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import 'package:pharmatec/app/services/clientServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientsController extends GetxController {
  var clients = <Client>[].obs; // RxList to hold client data
  var filteredClients = <Client>[].obs; // RxList for filtered clients
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;

  final ClientServices clientsService = ClientServices(); // Your service

  @override
  void onInit() {
    fetchClients();
    super.onInit();
  }

  Future<void> fetchClients() async {
    isLoading.value = true;
    try {
      final fetchedClients = await clientsService.fetchClients();
      clients.assignAll(fetchedClients);
      filteredClients.assignAll(fetchedClients);
    } catch (e) {
      errorMessage.value = 'Failed to fetch clients: $e';
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> saveClient(Client client) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('client_name', client.nom);
      await prefs.setString('client_id', client.id);
      
      Get.toNamed(Routes.HOME);
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error',
        'Failed to save client.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE74C3C).withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }
  void searchClients(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredClients.assignAll(clients);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredClients.assignAll(
        clients.where((client) {
          final idMatches = client.id.toString().toLowerCase().contains(lowerQuery) ;
          final nameMatches = client.nom.toLowerCase().contains(lowerQuery);
          return idMatches || nameMatches;
        }).toList(),
      );
    }
  }
}
