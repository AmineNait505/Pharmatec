import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/commandes_controller.dart';

class CommandesView extends GetView<CommandesController> {
  const CommandesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CommandesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CommandesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
