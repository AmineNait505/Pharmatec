import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
import '../controllers/addcommande_controller.dart';

class AddcommandeView extends GetView<AddcommandeController> {
  const AddcommandeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondColor,
        title: const Text('Add to Commande', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCategoryField(context),
            const SizedBox(height: 16),
            _buildArticleField(context),
            const SizedBox(height: 16),
            _buildPriceQuantityDiscountFields(),
            const SizedBox(height: 16),
        Obx(() {
              // Determine if the button should be enabled
              final isQuantityError = controller.quantityError.value.isNotEmpty;
              return ElevatedButton(
                onPressed: isQuantityError ? null : () {
                  controller.submitOrder();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isQuantityError ? Colors.grey : secondColor, // Button color
                 
                ),
                child:  Text('Add to Commande', style:TextStyle(color: isQuantityError ? Colors.grey[800] : Colors.white,) ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Category Field with search and dropdown functionality
  Widget _buildCategoryField(BuildContext context) {
    return Obx(() {
      final selectedCategory = controller.selectedCategory.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            focusNode: controller.categoryFocusNode,
            readOnly: true,
            onTap: () => _showCategoryDropdown(context),
            controller: TextEditingController(text:
              selectedCategory != null ?
              '${selectedCategory.description} (ID: ${selectedCategory.id})' : ''
            ),
            decoration: InputDecoration(
              labelText: 'Select Category',
              labelStyle: TextStyle(
                color: controller.categoryFocusNode.hasFocus ? primaryColor : Colors.black54,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: controller.categoryFocusNode.hasFocus ? primaryColor : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: primaryColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  // Article Field with dropdown functionality
  Widget _buildArticleField(BuildContext context) {
    return Obx(() {
      final selectedArticle = controller.selectedArticle.value;

      return TextField(
        focusNode: controller.articleFocusNode,
        readOnly: true,
        onTap: () => _showArticleDropdown(context),
        controller: TextEditingController(text:
          selectedArticle != null ?
          '${selectedArticle.nom} (ID: ${selectedArticle.id})' : ''
        ),
        decoration: InputDecoration(
          labelText: 'Select Article',
          labelStyle: TextStyle(
            color: controller.articleFocusNode.hasFocus ? primaryColor : Colors.black54,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: controller.articleFocusNode.hasFocus ? primaryColor : Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      );
    });
  }

  // Show Category Dropdown List
  void _showCategoryDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            TextField(
              onChanged: (query) => controller.filterCategories(query),
              decoration: const InputDecoration(
                labelText: 'Search Categories by ID',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red)),
                  );
                }

                if (controller.filteredCategories.isEmpty) {
                  return const Center(child: Text('No categories found'));
                }

                return ListView.builder(
                  itemCount: controller.filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = controller.filteredCategories[index];
                    return ListTile(
                      title: Text(category.description),
                      subtitle: Text('Code Catégorie: ${category.id}'),
                      onTap: () {
                        controller.selectCategory(category);
                        Navigator.pop(context); // Close the dropdown
                      },
                    );
                  },
                );
              }),
            ),
          ],
        );
      },
    );
  }

  // Show Article Dropdown List
  void _showArticleDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            TextField(
              onChanged: (query) {
                if (query.isEmpty) {
                  // Reset the filtered articles list when the query is empty
                  controller.filteredArticles.value = [];
                } else {
                  if (controller.selectedCategory.value != null) {
                    controller.filterArticles(query);
                  } else if (query.length >= 2) {
                    controller.fetchArticleByCode(query);
                  }
                }
              },
              decoration: const InputDecoration(
                labelText: 'Search Articles by ID',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(controller.errorMessage.value, style: const TextStyle(color: Colors.red)),
                  );
                }

                if (controller.filteredArticles.isEmpty) {
                  return const Center(child: Text('No articles found'));
                }

                return ListView.builder(
                  itemCount: controller.filteredArticles.length,
                  itemBuilder: (context, index) {
                    final article = controller.filteredArticles[index];
                    final stockStatus = article.qte > 0 ? 'En stock' : 'Hors stock';
                    return ListTile(
                      title: Text(article.nom),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ID: ${article.id}'),
                          Text(stockStatus, style: TextStyle(color: article.qte > 0 ? Colors.green : Colors.red)),
                        ],
                      ),
                      onTap: () {
                        controller.selectArticle(article);
                        Navigator.pop(context); // Close the dropdown
                      },
                    );
                  },
                );
              }),
            ),
          ],
        );
      },
    );
  }

  // Build fields for price, quantity, discount, and final price
  Widget _buildPriceQuantityDiscountFields() {
    return Obx(() {
      final selectedArticle = controller.selectedArticle.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedArticle != null) ...[
            // Price field
            TextField(
              controller: TextEditingController(text: '${controller.price.value.toStringAsFixed(2)}'),
              decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: TextStyle(
                  color: Colors.black54, // Default color
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            // Quantity field
            TextField(
              focusNode: controller.quantityFocusNode,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final intValue = int.tryParse(value) ?? 0;
                if (intValue > selectedArticle.qte) {
                  controller.showQuantityError(true); // Show error if exceeds
                } else {
                  controller.showQuantityError(false);
                  controller.updateQuantity(intValue);
                }
              },
              decoration: InputDecoration(
                labelText: 'Quantity',
                labelStyle: TextStyle(
                  color: controller.quantityFocusNode.hasFocus ? primaryColor : Colors.black54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: controller.quantityError.value.isNotEmpty ? controller.quantityError.value : null,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Discount field
            TextField(
              focusNode: controller.discountFocusNode,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final discountValue = double.tryParse(value) ?? 0.0;
                controller.updateDiscount(discountValue );
              },
              decoration: InputDecoration(
                labelText: 'Discount (%)',
                labelStyle: TextStyle(
                  color: controller.discountFocusNode.hasFocus ? primaryColor : Colors.black54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Final Price field
            TextField(
              controller: TextEditingController(text: '${controller.finalPrice.toStringAsFixed(2)}'),
              decoration: InputDecoration(
                labelText: 'Final Price',
                labelStyle: TextStyle(
                  color: Colors.black54, // Default color
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              readOnly: true,
            ),
          ],
        ],
      );
    });
  }
}
