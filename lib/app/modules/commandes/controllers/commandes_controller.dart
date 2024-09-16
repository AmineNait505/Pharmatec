import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/commande.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import 'package:pharmatec/app/services/commandeServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommandesController extends GetxController {
  var isLoading = false.obs;
  var commandes = <Commande>[].obs;
  var errorMessage = ''.obs;
  var filteredCommandes = <Commande>[].obs;

  final CommandeServices commandeServices = CommandeServices();
  final clientName = ''.obs;
  final contactId = ''.obs;
  var isMenuOpen=false.obs;

  @override
  void onInit() {
    super.onInit();
    loadClientData();
  }

  Future<void> fetchCommandes(String clientNumber,String ContactNo) async {
    if (clientNumber.isEmpty) return;
    isLoading.value = true;
    try {
      print('yesser $clientNumber');
      final fetchedCommandes = await commandeServices.fetchClients(clientNumber,ContactNo);
      commandes.assignAll(fetchedCommandes);
      searchCommandes('');
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
    clientName.value = prefs.getString('client_business_relation') ?? '';
    contactId.value = prefs.getString('contact_id') ?? '';
  
    if (clientName.isNotEmpty || contactId.isNotEmpty) {
  print("client business relatio ${clientName.value}");
      await fetchCommandes(clientName.value,contactId.value);
    }
  }

  Future<void> saveCommandeAndNavigate(String commandeNo,String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_commande_no', commandeNo);
    await prefs.setString('commandeStatus', status);
    print(commandeNo);
    Get.toNamed(Routes.DETAILS); 
  }
}
