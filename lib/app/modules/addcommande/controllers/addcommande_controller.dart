import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmatec/app/data/models/categories.dart';
import 'package:pharmatec/app/data/models/item.dart';
import 'package:pharmatec/app/services/categoriesServices.dart';
import 'package:pharmatec/app/services/articleServices.dart';
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
  var selectedArticles = <Item>[].obs; 

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
    Future<void> saveSelectedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> articlesJson = selectedArticles.map((article) => jsonEncode(article.toJson())).toList();
    await prefs.setStringList('selected_articles', articlesJson);
  }
void fetchArticlesByName(String articleName) async {
  try {
    isLoading(true);
    errorMessage('');
    
    if (articleName.length >= 2) {  
      if (selectedCategory.value == null) {
       
        final fetchedArticles = await ArticelServices().fetchArticlebyNO(articleName);
        articles.assignAll(fetchedArticles);
        filteredArticles.assignAll(fetchedArticles);
      } else {
        final fetchedArticles = await ArticelServices().fetchArticlebyCategories(selectedCategory.value!.id);
        articles.assignAll(fetchedArticles);
        filteredArticles.assignAll(
          fetchedArticles.where((article) => article.nom.toLowerCase().contains(articleName.toLowerCase())).toList(),
        );
      }
    } else {
      filteredArticles.clear();
    }
  } catch (e) {
    errorMessage(e.toString());
  } finally {
    isLoading(false);
  }
}


  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      errorMessage('');
      final fetchedCategories = await CategorieServices().fetchCategories();
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
      filteredArticles.clear(); 
      selectedArticle.value =null;
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

}
