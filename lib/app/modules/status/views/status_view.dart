import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import '../controllers/status_controller.dart';

class StatusView extends GetView<StatusController> {
  const StatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondColor,
        title: const Text('Statut du Client', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.clientStatus.isEmpty) {
            return const Center(
              child: Text(
                'Aucune information sur la situation trouvée',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            final status = controller.clientStatus.first;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Solde card with a pop-up action
                  _buildStatusCard(
                    'Solde:',
                    status.solde.toStringAsFixed(2),
                    status.solde > 0 ? Colors.green.shade100 : Colors.red.shade100,
                    () => _showSoldePopup(context, status.solde), // Custom action for Solde
                  ),
                  
                  // Solde Échu card
                  _buildStatusCard(
                    'Solde Échu:',
                    status.soldeEchu.toStringAsFixed(2),
                    Colors.white,
                    () {
                      // Custom action for Solde Échu (e.g., show another dialog)
                      _showGenericPopup(context, 'Solde Échu', status.soldeEchu);
                    },
                  ),
                  
                  // Paiement en Cours card
                  _buildStatusCard(
                    'Paiement en Cours:',
                    status.payementEnCours.toStringAsFixed(2),
                    Colors.white,
                    () {
                      // Custom action for Paiement en Cours
                      _showGenericPopup(context, 'Paiement en Cours', status.payementEnCours);
                    },
                  ),
                  
                  // Commande en Cours card (navigate to the COMMANDE page)
                  _buildStatusCard(
                    'Commande en Cours:',
                    status.commandeEnCours.toStringAsFixed(2),
                    Colors.white,
                    () => Get.toNamed(Routes.COMMANDES), // Navigate to Commande page
                  ),
                  
                  // Restant card
                  _buildStatusCard(
                    'Restant:',
                    status.restant.toStringAsFixed(2),
                    Colors.white,
                    () {
                      // Custom action for Restant
                      _showGenericPopup(context, 'Restant', status.restant);
                    },
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  // Build Status Card with custom onTap actions
  Widget _buildStatusCard(String label, String value, Color backgroundColor, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: backgroundColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        leading: Icon(
          Icons.info_outline,
          color: backgroundColor == Colors.white ? Colors.black : Colors.white,
          size: 30.0,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: backgroundColor == Colors.white ? Colors.black : Colors.white,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: backgroundColor == Colors.white ? Colors.black : Colors.white,
          ),
        ),
        onTap: onTap, // Execute the provided action when the card is tapped
      ),
    );
  }

  // Function to show the Solde pop-up
  void _showSoldePopup(BuildContext context, double solde) {
    Get.defaultDialog(
      title: 'Solde Information',
      middleText: 'Le solde actuel est: ${solde.toStringAsFixed(2)}',
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }

  // Generic pop-up function for other cards
  void _showGenericPopup(BuildContext context, String title, double value) {
    Get.defaultDialog(
      title: '$title Information',
      middleText: 'La valeur actuelle est: ${value.toStringAsFixed(2)}',
      textConfirm: 'OK',
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }
}
