import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
import '../controllers/clients_controller.dart';

class ClientsView extends GetView<ClientsController> {
  const ClientsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode searchFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondColor,
        title: const Text('Clients', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: searchFocusNode,
              onChanged: (query) => controller.searchClients(query),
              decoration: InputDecoration(
                hintText: 'Recherche par Nom ou par Code Client',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: secondColor),
                ),
                prefixIcon: Icon(Icons.search, color: searchFocusNode.hasFocus ? primaryColor : secondColor),
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

              if (controller.filteredClients.isEmpty) {
                return const Center(
                  child: Text('No clients found'),
                );
              }

              return ListView.builder(
                itemCount: controller.filteredClients.length,
                itemBuilder: (context, index) {
                  final client = controller.filteredClients[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                       onTap: () => controller.saveClient(client),
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: secondColor,
                        child: Text(
                          client.nom.substring(0, 2).toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        client.nom,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        client.id.toString(),
                        style: TextStyle(color: primaryColor.withOpacity(0.7)),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, color: secondColor),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
