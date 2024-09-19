import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/clientStatus.dart';
import 'package:pharmatec/app/services/clientServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusController extends GetxController {
  var clientId = ''.obs;
  var clientStatus = <ClientStatus>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadClientData();
  }

  Future<void> loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    clientId.value = prefs.getString('client_business_relation') ?? 'Unknown';

    if (clientId.isNotEmpty) {
      await fetchClientStatus();
    }
  }

  Future<void> fetchClientStatus() async {
    try {
      var status = await ClientServices().fetchClientStatus(clientId.value);
      clientStatus.assignAll(status);
    } catch (e) {
      print('Error fetching client status: $e');
    }
  }
}
