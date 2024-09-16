import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/core/values/colors.dart';
import 'package:pharmatec/app/routes/app_pages.dart';
import '../controllers/addcommande_controller.dart';

class AddcommandeView extends GetView<AddcommandeController> {
  const AddcommandeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondColor,
        title: const Text('Ajouter à la Commande', style: TextStyle(color: Colors.white)),
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
            _buildSelectedArticlesList(),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        return controller.selectedArticles.isNotEmpty
            ? FloatingActionButton(
                onPressed: () {
                  controller.saveSelectedArticles();
                  Get.toNamed(Routes.NEWCOMMANDE);
                },
                backgroundColor: secondColor,
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              )
            : SizedBox.shrink();
      }),
    );
  }

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
            controller: TextEditingController(
              text: selectedCategory != null
                  ? '${selectedCategory.description} (ID: ${selectedCategory.id})'
                  : '',
            ),
            decoration: InputDecoration(
              labelText: 'Sélectionner la Catégorie',
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

  Widget _buildArticleField(BuildContext context) {
    return Obx(() {
      final selectedArticle = controller.selectedArticle.value;
      final articleController = TextEditingController(
        text: selectedArticle != null
            ? '${selectedArticle.nom} (ID: ${selectedArticle.id})'
            : '',
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            focusNode: controller.articleFocusNode,
            readOnly: true,
            onTap: () => _showArticleDropdown(context),
            controller: articleController,
            decoration: InputDecoration(
              labelText: 'Sélectionner l\'Article',
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
          ),
        ],
      );
    });
  }

  Widget _buildSelectedArticlesList() {
    return Obx(() {
      if (controller.selectedArticles.isEmpty) {
        return const Text('Aucun article sélectionné');
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Articles Sélectionnés:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            itemCount: controller.selectedArticles.length,
            itemBuilder: (context, index) {
              final article = controller.selectedArticles[index];
              return ListTile(
                title: Text(
                  article.nom,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.qte > 0 ? 'En stock' : 'Rupture de stock',
                      style: TextStyle(
                        color: article.qte > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    Text(
                      '${article.price.toStringAsFixed(2)} TND',
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => controller.removeArticle(article),
                ),
              );
            },
          ),
        ],
      );
    });
  }

  void _showCategoryDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Obx(() {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) => controller.filterCategories(value),
                  decoration: InputDecoration(
                    hintText: 'Rechercher une Catégorie',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = controller.filteredCategories[index];
                    return ListTile(
                      title: Text(category.description),
                      subtitle: Text('ID: ${category.id}'),
                      onTap: () {
                        controller.selectCategory(category);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        });
      },
    );
  }

  void _showArticleDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Obx(() {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) => controller.fetchArticlesByName(value),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un Article',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.filteredArticles.length,
                  itemBuilder: (context, index) {
                    final article = controller.filteredArticles[index];
                    return ListTile(
                      title: Text(article.nom),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(article.id),
                          Text('${article.price.toStringAsFixed(2)} TND'),
                          Text(
                            article.qte > 0 ? 'En stock' : 'Rupture de stock',
                            style: TextStyle(
                              color: article.qte > 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        controller.selectArticle(article);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
