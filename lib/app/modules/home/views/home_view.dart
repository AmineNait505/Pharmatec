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
              // Conditional icons in the drawer
              Obx(() {
                if (controller.clientBusinessRelation.value != "NONE") {
                  return Column(
                    children: [
                      _buildDrawerIcon(Icons.payment, "Paiement", Routes.COMMANDES),
                      SizedBox(height: 20),
                      _buildDrawerIcon(Icons.shopping_cart, "Commande", Routes.COMMANDES),
                      SizedBox(height: 20),
                    ],
                  );
                } else {
                  return SizedBox.shrink(); // Hide icons if no business relation
                }
              }),
              _buildDrawerIcon(Icons.shop_2, "Commande Indirect", Routes.ADDCOMMANDE,),
              _buildDrawerIcon(Icons.location_on, "Visite", Routes.VISITE, arguments: {
                'from': Routes.HOME, 
              }),
              SizedBox(height: 20),
              _buildDrawerIcon(Icons.history, "Historique", Routes.COMMANDES),
              SizedBox(height: 20),
              _buildDrawerIcon(Icons.info, "Situation", Routes.STATUS),
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
            SizedBox(height: 10),
            
          Obx(() {
  if (controller.clientStatus.isNotEmpty && controller.clientStatus.first.cause_blocage != 'Non bloqué') {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(  // InkWell adds a ripple effect when clicked
        onTap: () {
          Get.toNamed(Routes.STATUS);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text(
              controller.clientStatus.first.cause_blocage ?? '',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  } else {
    return SizedBox.shrink(); 
  }
}),

            SizedBox(height: 20),
           
            Obx(() {
              if (controller.clientBusinessRelation.value != "NONE") {
                return Column(
                  children: [
                    _buildCard(Icons.payment, "Paiement", "Voir et gérer les paiements.", Routes.COMMANDES),
                    SizedBox(height: 10),
                    _buildCard(Icons.shopping_cart, "Commande / Devis", "Suivre et gérer les commandes.", Routes.COMMANDES),
                    SizedBox(height: 10),
                  ],
                );
              } else {
                return SizedBox.shrink(); // Hide cards if no business relation
              }
            }),
            _buildCard(Icons.shop_2, "Commande Indirect", "Suivre et gérer les commandes Indirect.", Routes.ADDCOMMANDE,
            arguments: {'isQuote':false,
            'isIndirect':true}),
            SizedBox(height: 10),
            // Other cards
            _buildCard(Icons.location_on, "Visite", "Planifier et suivre les visites.", Routes.CALENDAR, arguments: {
              'clientNo': controller.clientId.value,
              'contactNo': controller.contactId.value,
              'from': Get.currentRoute, 
            }),
            SizedBox(height: 10),
            _buildCard(Icons.history, "Historique", "Voir l'historique des commandes.", Routes.COMMANDES),
            SizedBox(height: 10),
            _buildCard(Icons.info, "Situation", "Vérifier la situation actuelle.", Routes.STATUS),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String description, String route, {Map<String, dynamic>? arguments}) {
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
          Get.toNamed(route, arguments: arguments); // Pass arguments during navigation
        },
      ),
    );
  }

  Widget _buildDrawerIcon(IconData icon, String label, String route, {Map<String, String>? arguments}) {
    return IconButton(
      icon: Icon(icon, color: secondColor),
      onPressed: () {
        Get.toNamed(route, arguments: arguments); // Pass arguments during navigation
      },
    );
  }
}
