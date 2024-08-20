import 'package:get/get.dart';

import '../controllers/addcommande_controller.dart';

class AddcommandeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddcommandeController>(
      () => AddcommandeController(),
    );
  }
}
