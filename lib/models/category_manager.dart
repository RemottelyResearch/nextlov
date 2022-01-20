import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'category_model.dart';

class CategoryManager extends ChangeNotifier {
  CategoryManager() {
    _loadAllCategories();
  }

  final Firestore firestore = Firestore.instance;

  List<CategoryModel> allCategories = [];

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  String categoryId = '';

  List<CategoryModel> get filteredCategories {
    final List<CategoryModel> filteredCategories = [];

    if (search.isEmpty) {
      filteredCategories.addAll(allCategories);
    } else {
      filteredCategories.addAll(allCategories
          .where((p) => p.name.toLowerCase().contains(search.toLowerCase())));
    }

    return filteredCategories;
  }

  Future<void> _loadAllCategories() async {
    final QuerySnapshot snapCategories = await firestore
        .collection('categories')
        .where('deleted', isEqualTo: false)
        .getDocuments();

    allCategories = snapCategories.documents
        .map((d) => CategoryModel.fromDocument(d))
        .toList();

    notifyListeners();
  }

  CategoryModel findCategoryById(String id) {
    try {
      return allCategories.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(CategoryModel category) {
    allCategories.removeWhere((p) => p.id == category.id);
    allCategories.add(category);
    notifyListeners();
  }

  void delete(CategoryModel category) {
    category.delete();
    allCategories.removeWhere((p) => p.id == category.id);
    notifyListeners();
  }
}
