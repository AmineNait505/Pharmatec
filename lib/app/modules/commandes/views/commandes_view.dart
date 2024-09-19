import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
import 'package:pharmatec/app/data/models/commande.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import '../controllers/commandes_controller.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CommandesView extends StatefulWidget {
  @override
  _CommandesViewState createState() => _CommandesViewState();
}

class _CommandesViewState extends State<CommandesView> with SingleTickerProviderStateMixin {
  final CommandesController controller = Get.find();
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Initialize the controller with the default tab's document type
    controller.documentType.value = 'Order';
    controller.fetchCommandes(controller.clientName.value,controller.contactId.value,controller.documentType.value);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_getAppBarTitle(_selectedIndex)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: secondColor,
          labelColor: secondColor,
          unselectedLabelColor: Colors.grey,
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
      body: RefreshIndicator(
        onRefresh: () async {
          _onTabChanged();
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildCommandesContent('Order'),
            _buildCommandesContent('Blanket Order'),
            _buildCommandesContent('Quote'),
          ],
        ),
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
                Get.toNamed(Routes.ADDCOMMANDE,arguments: {'isQuote': false,'isIndirect': false});
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.request_quote_sharp),
              label: 'Passer un devis',
              onTap: () {Get.toNamed(Routes.ADDCOMMANDE,arguments: {'isQuote': true,'isIndirect': false});},
            ),
          ],
        );
      }),
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
Widget _buildCommandesContent(String type) {
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
          List<Commande> filteredCommandes;
          if (type == 'Order') {
            filteredCommandes = controller.filteredCommandesOrder;
          } else if (type == 'Blanket Order') {
            filteredCommandes = controller.filteredCommandesBlanketOrder;
          } else {
            filteredCommandes = controller.filteredCommandesQuote;
          }

          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Text(controller.errorMessage.value),
            );
          }

          if (filteredCommandes.isEmpty) {
            return const Center(
              child: Text('No commandes found'),
            );
          }

          return ListView.builder(
            itemCount: filteredCommandes.length,
            itemBuilder: (context, index) {
              final commande = filteredCommandes[index];
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns items in the row
                        children: [
                          RichText(
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
                          // Add the download icon at the extreme right
                          if (type == 'Quote')
                            IconButton(
                              icon: Icon(Icons.download, color: secondColor),
                              onPressed: () {
                                // Call the method to download the file
                                //controller.downloadFile(commande.downloadLink);
                              },
                            ),
                        ],
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


  void _onTabChanged() {
    final index = _tabController.index;
    String documentType;

    switch (index) {
      case 0:
        documentType = 'Order';
        break;
      case 1:
        documentType = 'Blanket Order';
        break;
      case 2:
        documentType = 'Quote';
        break;
      default:
        documentType = 'Order';
    }

    setState(() {
      _selectedIndex = index;
    });
    controller.fetchCommandes(controller.clientName.value,controller.contactId.value,documentType);
  }
}
