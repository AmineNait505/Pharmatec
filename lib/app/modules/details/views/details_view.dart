// ignore_for_file: use_super_parameters, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
import '../controllers/details_controller.dart';

class DetailsView extends GetView<DetailsController> {
  const DetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: secondColor,
        title: const Text('Details Commande ',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(icon:Icon(Icons.keyboard_backspace,color: Colors.white,),onPressed: () => Get.back(), ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        if (controller.articles.isEmpty) {
          return const Center(
            child: Text(
              'No articles found',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.articles.length,
          itemBuilder: (context, index) {
            final article = controller.articles[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Article Code : ${article.id}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Quantité:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('${article.qte}', style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Remise:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('${article.remise}%', style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Prix:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('${article.price} TND', style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('${article.totalLine} TND', style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
       floatingActionButton: Obx(() {
        
        return controller.CommandeStatus.value == 'Open'
            ? FloatingActionButton(
                backgroundColor: secondColor,
                onPressed: () {
                  // Add your logic here
                },
                child: const Icon(Icons.add, color: Colors.white),
                tooltip: 'Add Lines in the commande',
              )
            : SizedBox.shrink(); 
      }),
    );
  }
}
