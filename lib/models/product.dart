import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:nextlov/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  Product(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.sizes,
      this.categoryId,
      this.deleted = false}) {
    images = images ?? [];
    sizes = sizes ?? [];
  }

  Product.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document['name'] as String;
    categoryId = document['categoryId'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data['images'] as List<dynamic>);
    deleted = (document.data['deleted'] ?? false) as bool;
    sizes = (document.data['sizes'] as List<dynamic> ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  StorageReference get storageRef => storage.ref().child('products').child(id);

  String id;
  String name;
  String categoryId;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  List<dynamic> newImages;

  bool deleted;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;
  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0 && !deleted;
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes) {
      if (size.price < lowest) lowest = size.price;
    }
    return lowest;
  }

  ItemSize findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> exportSizeList() {
    return sizes.map((size) => size.toMap()).toList();
  }

  Future<void> save({String categoryId}) async {
    loading = true;

    final Map<String, dynamic> data = {
      'name': name,
      'categoryId': categoryId,
      'description': description,
      'sizes': exportSizeList(),
      'deleted': deleted
    };

    if (id == null) {
      final doc = await firestore
          .collection('categories')
          .document(categoryId)
          .collection('products')
          .add(data);
      await firestore
          .collection('products')
          .document(doc.documentID)
          .setData(data);

      id = doc.documentID;
    } else {
      await firestore
          .document('categories/$categoryId/products/$id')
          .updateData(data);
      await firestore.collection('products').document(id).updateData(data);
    }

    final List<String> updateImages = [];

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      }
    }

    for (final image in images) {
      if (!newImages.contains(image) && image.contains('firebase')) {
        try {
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        } catch (e) {
          debugPrint('Falha ao deletar $image');
        }
      }
    }

    await firestore
        .document('categories/$categoryId/products/$id')
        .updateData({'images': updateImages});
    await firestore
        .document('products/$id')
        .updateData({'images': updateImages});

    images = updateImages;

    loading = false;
  }

  void deleteCategoryProduct(String categoryId) {
    firestore
        .document('categories/$categoryId/products/$id')
        .updateData({'deleted': true});
    deleteProductsProduct();
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      categoryId: categoryId,
      description: description,
      images: List.from(images),
      sizes: sizes.map((size) => size.clone()).toList(),
      deleted: deleted,
    );
  }

//________________________
  void deleteProductsProduct() {
    firestore.document('products/$id').updateData({'deleted': true});
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, categoryId: $categoryId, sizes: $sizes, newImages: $newImages}';
  }
}
