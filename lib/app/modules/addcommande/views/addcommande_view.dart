import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/addcommande_controller.dart';

class AddcommandeView extends GetView<AddcommandeController> {
  const AddcommandeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddcommandeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AddcommandeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
