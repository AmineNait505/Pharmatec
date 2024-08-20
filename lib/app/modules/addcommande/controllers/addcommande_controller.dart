import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/services/articleServices.dart';
import 'package:pharmatec/app/services/categoriesServices.dart';
import 'package:pharmatec/app/services/commandeServices.dart';
import 'package:pharmatec/app/data/models/item.dart';
import 'package:pharmatec/app/data/models/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddcommandeController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var categories = <Categorie>[].obs;
  var filteredCategories = <Categorie>[].obs;
  var selectedCategory = Rx<Categorie?>(null);
  final categoryFocusNode = FocusNode();
  final articleFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();
  final discountFocusNode = FocusNode();
  final clientId = ''.obs;
  var articles = <Item>[].obs;
  var filteredArticles = <Item>[].obs;
  var selectedArticle = Rx<Item?>(null);
  var price = 0.obs;
  var finalPrice=0.0.obs;
  var quantity = 0.obs;
  var discount = 0.0.obs;
  var quantityError = ''.obs; // Error message for quantity
  var isCalculating = false.obs; 
  var salesperson = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    getSalespersonInfo();
    loadClientData();
  }

  @override
  void onClose() {
    // Dispose FocusNodes
    categoryFocusNode.dispose();
    articleFocusNode.dispose();
    quantityFocusNode.dispose();
    discountFocusNode.dispose();
    super.onClose();
  }

  Future<void> getSalespersonInfo() async {
    final prefs = await SharedPreferences.getInstance();
    salesperson.value = prefs.getString('salesperson') ?? 'No salesperson info';
    print('Salesperson info retrieved: ${salesperson.value}'); // Debugging line
  }

  void fetchCategories() async {
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
      filteredArticles.value = [];
    } else {
      // Select the new category
      selectedCategory.value = category;
      fetchArticles(category.id);
    }
  }

  void calculateFinalPrice() {
    final itemPrice = price.value;
    final itemQuantity = quantity.value;
    final itemDiscount = discount.value;

    final totalPrice = itemPrice * itemQuantity;
    final discountedPrice = totalPrice - (totalPrice * itemDiscount / 100);

    finalPrice.value = discountedPrice;
    isCalculating.value = false; // Update status once calculation is complete
  }

  void selectArticle(Item article) {
    if (selectedArticle.value == article) {
      selectedArticle.value = null;
      price.value = 0;
      quantity.value = 0;
      discount.value = 0;
      quantityError.value = '';
    } else {
      // Select the new article
      selectedArticle.value = article;
      price.value = article.price;
    }
  }

  void fetchArticleByCode(String code) async {
    try {
      isLoading(true);
      errorMessage('');
      final fetchedArticles = await ArticelServices().fetchArticlebyNO(code);
      if (fetchedArticles.isNotEmpty) {
        filteredArticles.assignAll(fetchedArticles);
      } else {
        errorMessage('No articles found for the code');
        filteredArticles.clear();
      }
    } catch (e) {
      errorMessage(e.toString());
      filteredArticles.clear();
    } finally {
      isLoading(false);
    }
  }

  void updateQuantity(int value) {
    quantity.value = value;
    calculateFinalPrice();
  }

  void updateDiscount(double value) {
    discount.value = value;
    calculateFinalPrice();
  }

  // Show or hide quantity error
  void showQuantityError(bool show) {
    quantityError.value = show ? 'Quantity exceeds available stock' : '';
  }
   Future<void> loadClientData() async {
    final prefs = await SharedPreferences.getInstance();
    clientId.value = prefs.getString('client_id') ?? '';
  }

  Future<void> submitOrder() async {
    print("le client id");
    final result = await CommandeServices().createOrderLine(
      clientNo: clientId.value,
      itemNo: selectedArticle.value!.id, 
      qty: quantity.value.toString(),
      salespersonCode: salesperson.value,
    );

    if (result.startsWith('Success')) {
      Get.snackbar('Success', result,
          backgroundColor: Colors.green, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      
      selectedArticle.value = null;
      price.value = 0;
      quantity.value = 0;
      discount.value = 0;
      finalPrice.value = 0.0;
      quantityError.value = '';
    } else {
      Get.snackbar('Error', result,
          backgroundColor: Colors.red, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
