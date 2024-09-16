import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
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
                  _buildStatusCard(
                    'Solde:',
                    status.solde.toStringAsFixed(2),
                    status.solde > 0 ? Colors.green.shade100 : Colors.red.shade100,
                  ),
                  _buildStatusCard(
                    'Solde Échu:',
                    status.soldeEchu.toStringAsFixed(2),
                    Colors.white,
                  ),
                  _buildStatusCard(
                    'Paiement en Cours:',
                    status.payementEnCours.toStringAsFixed(2),
                    Colors.white,
                  ),
                  _buildStatusCard(
                    'Commande en Cours:',
                    status.commandeEnCours.toStringAsFixed(2),
                    Colors.white,
                  ),
                  _buildStatusCard(
                    'Restant:',
                    status.restant.toStringAsFixed(2),
                    Colors.white,
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildStatusCard(String label, String value, Color backgroundColor) {
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
      ),
    );
  }
}
