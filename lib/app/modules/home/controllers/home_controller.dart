import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final clientName = ''.obs;
  final clientId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadClientData();
  }

  Future<void> loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    clientName.value = prefs.getString('client_name')! ;
    clientId.value = prefs.getString('client_id') !;
  }
}
