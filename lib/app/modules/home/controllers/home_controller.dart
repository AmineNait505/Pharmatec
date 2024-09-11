import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final clientName = ''.obs;
  final contactName = ''.obs;
  final clientId = ''.obs;
  final clientBusinessRelation = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadClientData();
  }

  Future<void> loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    clientName.value = prefs.getString('client_name') ?? 'Unknown';
    clientId.value = prefs.getString('client_id') ?? 'Unknown';
    clientBusinessRelation.value = prefs.getString('client_business_relation') ?? 'Unknown';
    contactName.value = prefs.getString('contact_name') ?? ''; 
  }
}
