import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/categories.dart';
import 'package:pharmatec/app/data/models/item.dart';
import 'package:pharmatec/app/services/categoriesServices.dart';
import 'package:pharmatec/app/services/articleServices.dart';
import 'package:pharmatec/app/services/commandeServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddcommandeController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var categories = <Categorie>[].obs;
  var filteredCategories = <Categorie>[].obs;
  var selectedCategory = Rx<Categorie?>(null);
  final categoryFocusNode = FocusNode();
  final articleFocusNode = FocusNode();
  var articles = <Item>[].obs;
  var filteredArticles = <Item>[].obs;
  var selectedArticle = Rx<Item?>(null);
  var selectedArticles = <Item>[].obs; // List of selected articles

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  @override
  void onClose() {
    categoryFocusNode.dispose();
    articleFocusNode.dispose();
    super.onClose();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      errorMessage('');
      final fetchedCategories = await CategorieServices().fetchClients();
      categories.assignAll(fetchedCategories);
      filteredCategories.assignAll(fetchedCategories);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void filterCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      filteredCategories.assignAll(
        categories.where((category) => category.description.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  void fetchArticles(String categoryCode) async {
    try {
      isLoading(true);
      errorMessage('');
      final fetchedArticles = await ArticelServices().fetchArticlebyCategories(categoryCode);
      articles.assignAll(fetchedArticles);
      filteredArticles.assignAll(fetchedArticles);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void filterArticles(String query) {
    if (query.isEmpty) {
      filteredArticles.assignAll(articles);
    } else {
      filteredArticles.assignAll(
        articles.where((article) => article.nom.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  void selectCategory(Categorie category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = null;
      filteredArticles.clear(); // Clear articles when category is deselected
    } else {
      selectedCategory.value = category;
      fetchArticles(category.id);
    }
  }
  void removeArticle(Item article) {
  selectedArticles.remove(article);
}

  void selectArticle(Item article) {
    if (selectedArticles.contains(article)) {
      selectedArticles.remove(article);
    } else {
      selectedArticle.value=article;
      selectedArticles.add(article);
    }
  }

  /*void submitOrder() async {
    if (selectedArticles.isEmpty) {
      Get.snackbar('Error', 'Please select at least one article.',
          backgroundColor: Colors.red, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Implement order submission logic here
    // Example:
    final result = await CommandeServices().createOrderLine(
      // Your order line creation logic here
    );

    if (result.startsWith('Success')) {
      Get.snackbar('Success', result,
          backgroundColor: Colors.green, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);

      selectedArticles.clear(); // Clear selected articles after submission
    } else {
      Get.snackbar('Error', result,
          backgroundColor: Colors.red, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }*/
}
