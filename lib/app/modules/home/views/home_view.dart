import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      drawer: FractionallySizedBox(
        widthFactor: 0.25,
        child: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Conditionally show "Paiement" and "Commande" icons in the drawer
              Obx(() {
                if (controller.clientBusinessRelation.value != "NONE") {
                  return Column(
                    children: [
                      _buildDrawerIcon(Icons.payment, "Paiement"),
                      SizedBox(height: 20),
                      _buildDrawerIcon(Icons.shopping_cart, "Commande"),
                      SizedBox(height: 20),
                    ],
                  );
                } else {
                  return SizedBox.shrink(); // No icons if business_relation is "NONE"
                }
              }),
              _buildDrawerIcon(Icons.location_on, "Visite"),
              SizedBox(height: 20),
              _buildDrawerIcon(Icons.history, "Historique"),
              SizedBox(height: 20),
              _buildDrawerIcon(Icons.info, "Situation"),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Obx(() => Align(
              alignment: Alignment.centerRight,
              child: Text(
                controller.contactName.value.isNotEmpty
                    ? controller.contactName.value
                    : controller.clientName.value,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
            SizedBox(height: 10),
            Obx(() => Align(
              alignment: Alignment.centerRight,
              child: Text(
                controller.contactName.value.isNotEmpty
                    ? 'Client: ${controller.clientName.value}'
                    : "Code Client : ${controller.clientId.value}",
                style: TextStyle(
                  color: primaryColor.withOpacity(0.7),
                  fontSize: 18,
                ),
              ),
            )),
            SizedBox(height: 20),
            
            // Conditionally show "Paiement" and "Commande" cards based on business relation
            Obx(() {
              if (controller.clientBusinessRelation.value != "NONE") {
                return Column(
                  children: [
                    _buildCard(Icons.payment, "Paiement", "View and manage payments."),
                    SizedBox(height: 10),
                    _buildCard(Icons.shopping_cart, "Commande", "Track and manage orders."),
                    SizedBox(height: 10),
                  ],
                );
              } else {
                return SizedBox.shrink(); // No cards if business_relation is "NONE"
              }
            }),

            // Other cards
            _buildCard(Icons.location_on, "Visite", "Schedule and track visits."),
            SizedBox(height: 10),
            _buildCard(Icons.history, "Historique", "View order history."),
            SizedBox(height: 10),
            _buildCard(Icons.info, "Situation", "Check the current situation."),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String description) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: secondColor,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: secondColor),
        onTap: () {
          Get.toNamed(Routes.COMMANDES);
        },
      ),
    );
  }

  Widget _buildDrawerIcon(IconData icon, String label) {
    return IconButton(
      icon: Icon(icon, color: secondColor),
      onPressed: () {
        Get.toNamed(Routes.COMMANDES);
      },
    );
  }
}
