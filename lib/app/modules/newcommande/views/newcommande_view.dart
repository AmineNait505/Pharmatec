import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/newcommande_controller.dart';

class NewcommandeView extends GetView<NewcommandeController> {
  const NewcommandeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewcommandeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NewcommandeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
