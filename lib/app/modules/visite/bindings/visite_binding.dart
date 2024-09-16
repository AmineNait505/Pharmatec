import 'package:get/get.dart';

import '../controllers/visite_controller.dart';

class VisiteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisiteController>(
      () => VisiteController(),
    );
  }
}
