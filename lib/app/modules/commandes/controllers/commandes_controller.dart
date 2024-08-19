import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/commande.dart';
import 'package:pharmatec/app/services/commandeServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommandesController extends GetxController {
  var isLoading = false.obs;
  var commandes = <Commande>[].obs;
  var errorMessage = ''.obs;
  var filteredCommandes = <Commande>[].obs;

  final CommandeServices commandeServices = CommandeServices();
  final clientName = ''.obs;
  final clientId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadClientData();
  }

  Future<void> fetchCommandes(String clientNumber) async {
    if (clientNumber.isEmpty) return; // Check for empty clientNumber
    isLoading.value = true;
    try {
      final fetchedCommandes = await commandeServices.fetchClients(clientNumber);
      commandes.assignAll(fetchedCommandes);
      searchCommandes(''); // To initialize filteredCommandes with all fetched commandes
    } catch (e) {
      errorMessage.value = 'Failed to fetch commandes: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void searchCommandes(String query) {
    if (query.isEmpty) {
      filteredCommandes.value = commandes;
    } else {
      filteredCommandes.value = commandes.where((commande) {
        final idMatch = commande.id.toLowerCase().contains(query.toLowerCase());
        final dateMatch = commande.date.toLowerCase().contains(query.toLowerCase());
        return idMatch || dateMatch;
      }).toList();
    }
  }

  Future<void> loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    clientName.value = prefs.getString('client_name') ?? '';
    clientId.value = prefs.getString('client_id') ?? '';

    if (clientId.isNotEmpty) {
      await fetchCommandes(clientId.value);
    }
  }
}
