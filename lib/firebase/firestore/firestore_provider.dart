import 'package:flutter/material.dart';
import '../../../models/item_model.dart';
import 'firestore_service.dart';

class FirestoreProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  List<ItemModel> _items = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<ItemModel> get items => _items;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Listen to items stream — call this when screen opens
  void listenToItems() {
    _service.getItems().listen((itemsList) {
      _items = itemsList;
      notifyListeners(); // UI auto updates whenever Firestore changes
    });
  }

  // ADD item
  Future<void> addItem(String title, String description) async {
    _isLoading = true;
    notifyListeners();

    ItemModel newItem = ItemModel(
      title: title,
      description: description,
    );

    await _service.addItem(newItem);

    _isLoading = false;
    notifyListeners();
  }

  // UPDATE item
  Future<void> updateItem(String docId, String title, String description) async {
    _isLoading = true;
    notifyListeners();

    ItemModel updatedItem = ItemModel(
      title: title,
      description: description,
    );

    await _service.updateItem(docId, updatedItem);

    _isLoading = false;
    notifyListeners();
  }

  // DELETE item
  Future<void> deleteItem(String docId) async {
    await _service.deleteItem(docId);
    // No need to manually update _items list
    // because stream will auto update it
  }
}