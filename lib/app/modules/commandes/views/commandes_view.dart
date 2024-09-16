import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import '../controllers/commandes_controller.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CommandesView extends StatefulWidget {
  const CommandesView({Key? key}) : super(key: key);

  @override
  _CommandesViewState createState() => _CommandesViewState();
}

class _CommandesViewState extends State<CommandesView> {
  final CommandesController controller = Get.find();
  int _selectedIndex = 0; // Track the selected tab index

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(_getAppBarTitle(_selectedIndex)),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              Tab(text: 'Commandes'),
              Tab(text: 'Brouillons'),
              Tab(text: 'Devis'),
            ],
          ),
        ),
        drawer: FractionallySizedBox(
          widthFactor: 0.25,
          child: Drawer(
            backgroundColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildDrawerIcon(Icons.payment, "Paiement"),
                const SizedBox(height: 20),
                _buildDrawerIcon(Icons.shopping_cart, "Commande"),
                const SizedBox(height: 20),
                _buildDrawerIcon(Icons.location_on, "Visite"),
                const SizedBox(height: 20),
                _buildDrawerIcon(Icons.history, "Historique"),
                const SizedBox(height: 20),
                _buildDrawerIcon(Icons.info, "Situation"),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildCommandesContent(),
            _buildCommandesContent(),
            _buildCommandesContent(),
          ],
        ),
        floatingActionButton: Obx(() {
          return SpeedDial(
            icon: controller.isMenuOpen.value ? Icons.close : Icons.arrow_forward,
            backgroundColor: secondColor,
            foregroundColor: Colors.white,
            onOpen: () => controller.isMenuOpen.value = true,
            onClose: () => controller.isMenuOpen.value = false,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.add),
                label: 'Passer une Commande',
                onTap: () {
                  Get.toNamed(Routes.ADDCOMMANDE);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.request_quote_sharp),
                label: 'Passer un devis',
                onTap: () {},
              ),
            ],
          );
        }),
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 1:
        return 'Brouillons';
      case 2:
        return 'Devis';
      default:
        return 'Commandes';
    }
  }

  Widget _buildDrawerIcon(IconData icon, String label) {
    return IconButton(
      icon: Icon(icon, color: secondColor),
      onPressed: () {
        Get.toNamed(Routes.COMMANDES);
      },
    );
  }

  Widget _buildCommandesContent() {
    return Column(
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
                        Center(
                          child: RichText(
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
                          ),
                        ),
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
                              controller.saveCommandeAndNavigate(commande.id, commande.status);
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
    );
  }
}
