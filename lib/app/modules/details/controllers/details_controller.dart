import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/article.dart';
import 'package:pharmatec/app/services/commandeServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsController extends GetxController {
  //TODO: Implement DetailsController
    var articles = <Article>[].obs; 
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final  CommandeServices commandservice=CommandeServices();
  final count = 0.obs;
  final CommandeNo = ''.obs;
  final CommandeStatus = ''.obs;
  @override
  void onInit() {
    super.onInit();
    loadClientData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
   
    Future<void> fetchLines(String clientNumber) async {
    if (clientNumber.isEmpty) return;
    isLoading.value = true;
    try {
      final fetchedCommandes = await commandservice.fetchLines(clientNumber);
      articles.assignAll(fetchedCommandes);
      
    } catch (e) {
      errorMessage.value = 'Failed to fetch commandes: $e';
    } finally {
      isLoading.value = false;
    }
  }
    
    Future<void> loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    CommandeNo.value = prefs.getString('selected_commande_no') ?? '';
    CommandeStatus.value=prefs.getString('commandeStatus') ?? '';
    if (CommandeNo.isNotEmpty) {
      await fetchLines(CommandeNo.value);
    }
  }
}
