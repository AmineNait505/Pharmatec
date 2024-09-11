import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
import '../controllers/newcommande_controller.dart';

class NewcommandeView extends GetView<NewcommandeController> {
  const NewcommandeView({super.key});
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: secondColor,
      title: const Text('Articles Sélectionnés', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    body: Obx(() {
      if (controller.selectedArticles.isEmpty) {
        return const Center(child: Text('Aucun article sélectionné'));
      }

      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.selectedArticles.length,
              itemBuilder: (context, index) {
                final item = controller.selectedArticles[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nom,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Prix: ${item.price.toStringAsFixed(2)} TND',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              item.qte > 0 ? 'En stock' : 'Hors stock',
                              style: TextStyle(
                                color: item.qte > 0 ? Colors.green : Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                return TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Quantité désirée',
                                    errorText: controller.getQuantityError(item),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: controller.getQuantityError(item) == null
                                            ? Colors.grey
                                            : Colors.red,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    final newQuantity = int.tryParse(value) ?? 0;
                                    controller.validateQuantity(item, newQuantity); // Validate and store quantity
                                  },
                                );
                              }),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Obx(() {
                                return TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Remise %',
                                    errorText: controller.getDiscountError(item),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: controller.getDiscountError(item) == null
                                            ? Colors.grey
                                            : Colors.red,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    final newDiscount = int.tryParse(value) ?? 0;
                                    controller.validateDiscount(item, newDiscount); // Validate and store discount
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Display the total price at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              return Text(
                'Prix total: ${controller.calculateTotalPrice().toStringAsFixed(2)} TND',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              );
            }),
          ),
        ],
      );
    }),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        controller.submitOrder();
      },
      backgroundColor: secondColor,
      tooltip: 'Valider la commande',
      child: const Icon(Icons.check, color: Colors.white),
    ),
  );
}
}