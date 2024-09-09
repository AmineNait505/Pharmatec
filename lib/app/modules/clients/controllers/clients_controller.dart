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
  var clientTypes = <TypeClient>[].obs;
  var selectedClientType = Rx<TypeClient?>(null);
  final ClientServices clientsService = ClientServices();

  @override
  void onInit() {
    fetchClientTypes(); 
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

  Future<void> fetchClientsByType() async {
    if (selectedClientType.value == null) return;

    isLoading.value = true;
    try {
      final fetchedClients = await clientsService.fetchClientsByType(
        selectedClientType.value!.id,
        ''
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

  // Save client or contact info and navigate to home page
  Future<void> saveAndNavigateToHome(Client client, [Client? contact]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Save client info
    await prefs.setString('client_id', contact?.id ?? client.id);
    await prefs.setString('client_name', contact?.nom ?? client.nom);

    // Navigate to home page
    Get.toNamed(Routes.HOME); // Replace '/home' with your home page route
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
}
