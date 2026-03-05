import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'sqlite_service.dart';

class SqliteProvider extends ChangeNotifier {
  final SqliteService _service = SqliteService();

  List<ItemModel> _items = [];
  bool _isLoading = false;

  // Getters
  List<ItemModel> get items => _items;
  bool get isLoading => _isLoading;

  // Load all items from SQLite — call this when screen opens
  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    _items = await _service.getItems();

    _isLoading = false;
    notifyListeners();
  }

  // ADD item
  Future<void> addItem(String title, String description) async {
    ItemModel newItem = ItemModel(
      title: title,
      description: description,
    );

    await _service.addItem(newItem);
    await loadItems(); // reload list after adding
  }

  // UPDATE item
  Future<void> updateItem(int id, String title, String description) async {
    ItemModel updatedItem = ItemModel(
      id: id,
      title: title,
      description: description,
    );

    await _service.updateItem(updatedItem);
    await loadItems(); // reload list after updating
  }

  // DELETE item
  Future<void> deleteItem(int id) async {
    await _service.deleteItem(id);
    await loadItems(); // reload list after deleting
  }
}