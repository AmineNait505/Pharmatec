import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/status_controller.dart';

class StatusView extends GetView<StatusController> {
  const StatusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StatusView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StatusView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
