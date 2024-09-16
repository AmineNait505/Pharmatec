import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/visite_controller.dart';

class VisiteView extends GetView<VisiteController> {
  const VisiteView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VisiteView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VisiteView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
