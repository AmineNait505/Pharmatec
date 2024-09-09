import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
import 'package:pharmatec/app/data/models/TypeClient.dart';
import '../controllers/clients_controller.dart';

class ClientsView extends GetView<ClientsController> {
  const ClientsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode searchFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondColor,
        title: const Text(
          'Clients',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Obx(() {
              return Row(
                children: [
                  const Text(
                    'Choisir le type de client:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<TypeClient>(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      value: controller.selectedClientType.value,
                      onChanged: (TypeClient? newValue) {
                        controller.selectedClientType.value = newValue;
                        controller.fetchClientsByType();
                      },
                      items: controller.clientTypes.map((TypeClient typeClient) {
                        return DropdownMenuItem<TypeClient>(
                          value: typeClient,
                          child: Text(typeClient.name),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
            TextField(
              focusNode: searchFocusNode,
              onChanged: (query) => controller.searchClients(query),
              decoration: InputDecoration(
                hintText: 'Rechercher par nom ou par code client',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: secondColor),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: searchFocusNode.hasFocus ? secondColor : Colors.grey,
                ),
              ),
              cursorColor: secondColor,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                if (controller.filteredClients.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun client trouvé',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.filteredClients.length,
                  itemBuilder: (context, index) {
                    final client = controller.filteredClients[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent), // Remove divider lines
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.symmetric(horizontal: 16.0), // Adjust tile padding
                          childrenPadding: EdgeInsets.zero, // Remove padding for the children
                          title: Text(
                            client.nom,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Code: ${client.id}',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: secondColor,
                            child: Text(
                              client.nom.substring(0, 2).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          trailing: client.NbrContact == 0
                              ? Icon(Icons.arrow_forward_ios, color: Colors.grey) // Right arrow if no contacts
                              : null, // Default expand/collapse arrow if there are contacts
                          onExpansionChanged: (expanded) {
                            if (expanded) {
                              if (client.NbrContact == 0) {
                                // Directly navigate to home if no contacts
                                controller.saveAndNavigateToHome(client);
                              } else if (client.NbrContact > 0 && client.contacts == null) {
                                // Fetch contacts if available
                                controller.fetchClientContacts(client);
                              }
                            }
                          },
                          children: client.contacts == null && controller.isLoading.value
                              ? [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ]
                              : client.contacts?.map((contact) {
                                  return ListTile(
                                    title: Text(
                                      contact.nom,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    subtitle: Text('Code: ${contact.id}'),
                                    onTap: () {
                                      // Navigate with selected contact
                                      controller.saveAndNavigateToHome(client, contact);
                                    },
                                  );
                                }).toList() ?? [],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
