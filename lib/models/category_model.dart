import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:nextlov/models/item_size.dart';
import 'package:uuid/uuid.dart';

class CategoryModel extends ChangeNotifier {
  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.basePrice,
    this.images,
    this.deleted = false,
  }) {
    images = images ?? [];
  }

  CategoryModel.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document['name'] as String;
    description = document['description'] as String;
    basePrice = document['basePrice'] as double;
    images = List<String>.from(document.data['images'] as List<dynamic>);
    deleted = (document.data['deleted'] ?? false) as bool;
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.document('categories/$id');
  StorageReference get storageRef =>
      storage.ref().child('categories').child(id);

  String id;
  String name;
  double basePrice;
  String description;
  List<String> images;

  List<dynamic> newImages;

  bool deleted;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> save() async {
    loading = true;

    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'deleted': deleted
    };

    if (id == null) {
      final doc = await firestore.collection('categories').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
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

    await firestoreRef.updateData({'images': updateImages});

    images = updateImages;

    loading = false;
  }

  void delete() {
    firestoreRef.updateData({'deleted': true});
  }

  CategoryModel clone() {
    return CategoryModel(
      id: id,
      name: name,
      basePrice: basePrice,
      description: description,
      images: List.from(images),
      deleted: deleted,
    );
  }

  @override
  String toString() {
    return 'CategoryModel{id: $id, name: $name, description: $description, images: $images, basePrice: $basePrice, newImages: $newImages}';
  }
}
