import 'package:get/get.dart';

import '../controllers/commandes_controller.dart';

class CommandesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommandesController>(
      () => CommandesController(),
    );
  }
}
