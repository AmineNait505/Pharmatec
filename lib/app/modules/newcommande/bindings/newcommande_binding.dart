import 'package:get/get.dart';

import '../controllers/newcommande_controller.dart';

class NewcommandeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewcommandeController>(
      () => NewcommandeController(),
    );
  }
}
