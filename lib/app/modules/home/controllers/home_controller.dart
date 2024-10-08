import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/clientStatus.dart';
import 'package:pharmatec/app/services/clientServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  final clientName = ''.obs;
  final contactName = ''.obs;
  final contactId = ''.obs;
  final clientId = ''.obs;
  final clientBusinessRelation = ''.obs;
  final solde=0.0.obs;
  var clientStatus = <ClientStatus>[].obs;
  final cuaseBlocage =''.obs;

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
     contactId.value = prefs.getString('contact_id') ?? ''; 

     if (clientBusinessRelation.isNotEmpty) {
      await fetchClientStatus();
    }
  }
    Future<void> fetchClientStatus() async {
    try {
      var status = await ClientServices().fetchClientStatus(clientBusinessRelation.value);
      clientStatus.assignAll(status);
      if(clientStatus.isNotEmpty){
        cuaseBlocage.value=clientStatus.first.cause_blocage!;
        solde.value=clientStatus.first.solde;
        final prefs =await SharedPreferences.getInstance();
        prefs.setString('cause_bloacage',cuaseBlocage.value);
        prefs.setDouble('solde',solde.value);
        print('chawki ${cuaseBlocage.value}');
      }
    } catch (e) {
      print('Error fetching client status: $e');
    }
  }
}
