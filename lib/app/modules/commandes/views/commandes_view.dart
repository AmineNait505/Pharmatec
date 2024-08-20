  // ignore_for_file: use_super_parameters

  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:pharmatec/app/core/values/colors.dart';
  import 'package:pharmatec/app/routes/app_pages.dart';
  import '../controllers/commandes_controller.dart';

  class CommandesView extends GetView<CommandesController> {
    const CommandesView({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: secondColor,
          title: const Text('Commandes', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: FractionallySizedBox(
          widthFactor: 0.25, 
          child: Drawer(
            backgroundColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center icons vertically
              children: <Widget>[
                _buildDrawerIcon(Icons.payment, "Paiement"),
                SizedBox(height: 20),
                _buildDrawerIcon(Icons.shopping_cart, "Commande"),
                SizedBox(height: 20),
                _buildDrawerIcon(Icons.location_on, "Visite"),
                SizedBox(height: 20),
                _buildDrawerIcon(Icons.history, "Historique"),
                SizedBox(height: 20),
                _buildDrawerIcon(Icons.info, "Situation"),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (query) => controller.searchCommandes(query),
                decoration: InputDecoration(
                  hintText: 'Rechercher par numéro de commande',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: secondColor),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
                cursorColor: secondColor,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(controller.errorMessage.value),
                  );
                }

                if (controller.filteredCommandes.isEmpty) {
                  return const Center(
                    child: Text('No commandes found'),
                  );
                }

                return ListView.builder(
                  itemCount: controller.filteredCommandes.length,
                  itemBuilder: (context, index) {
                    final commande = controller.filteredCommandes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: RichText(
                              text: TextSpan(
                                text: 'Commande No: ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                                children: [
                                  TextSpan(
                                    text: commande.id,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                text: 'Date: ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                ),
                                children: [
                                  TextSpan(
                                    text: commande.date,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                text: 'Type: ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                ),
                                children: [
                                  TextSpan(
                                    text: commande.documentType,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                text: 'Status: ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                ),
                                children: [
                                  TextSpan(
                                    text: commande.status,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: commande.status == 'Open'
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                text: 'Prix : ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${commande.price} TND',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  controller.saveCommandeAndNavigate(commande.id);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: secondColor,
                                ),
                                child: const Text('View Details'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondColor,
          onPressed: () {
            
          },
          child: const Icon(Icons.add,color: Colors.white,),
          tooltip: 'Add Lines in the commande',
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
