import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/TypeClient.dart';
import 'package:pharmatec/app/data/models/client.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import 'package:pharmatec/app/services/clientServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientsController extends GetxController {
  var clients = <Client>[].obs; 
  var filteredClients = <Client>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;
  var secteurCode = ''.obs;
  var clientTypes = <TypeClient>[].obs;
  var selectedClientType = Rx<TypeClient?>(null);
  final ClientServices clientsService = ClientServices();

  @override
  void onInit() {
    fetchClientTypes(); 
    loadClientData();
    super.onInit();
  }

  Future<void> fetchClientTypes() async {
    isLoading.value = true;
    try {
      final fetchedTypes = await clientsService.fetchTypeClients();
      clientTypes.assignAll(fetchedTypes);
    } catch (e) {
      errorMessage.value = 'Failed to fetch client types: $e';
    } finally {
      isLoading.value = false;
    }
  }
    Future<void> loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
   
    secteurCode.value = prefs.getString('secteur_code') ?? ''; 
  }

  Future<void> fetchClientsByType() async {
    if (selectedClientType.value == null) return;
    print('Territory_Code ${secteurCode.value}');
    isLoading.value = true;
    try {
      final fetchedClients = await clientsService.fetchClientsByType(
        selectedClientType.value!.id,
       secteurCode.value
      );
      clients.assignAll(fetchedClients);
      filteredClients.assignAll(fetchedClients);
    } catch (e) {
      errorMessage.value = 'Failed to fetch clients by type: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchClientContacts(Client client) async {
    isLoading.value = true;
    try {
      final contacts = await clientsService.fetchClientContacts(client.id);
      client.contacts = contacts;
      update(); 
    } catch (e) {
      errorMessage.value = 'Failed to fetch client contacts: $e';
    } finally {
      isLoading.value = false;
    }
  }

 Future<void> saveAndNavigateToHome(Client client, [Client? contact]) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('client_id', client.id);
  await prefs.setString('client_name', client.nom); 

  if (contact != null) {
   
    await prefs.setString('contact_id', contact.id);
    await prefs.setString('contact_name', contact.nom); 
  } else {
   
    await prefs.remove('contact_id');
    await prefs.remove('contact_name');
  }
  await prefs.setString('client_business_relation', client.business_relation);
  Get.toNamed(Routes.HOME);
}
  void searchClients(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredClients.assignAll(clients);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredClients.assignAll(
        clients.where((client) {
          final idMatches = client.id.toString().toLowerCase().contains(lowerQuery);
          final nameMatches = client.nom.toLowerCase().contains(lowerQuery);
          return idMatches || nameMatches;
        }).toList(),
      );
    }
  }
    Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved data
  }
}
