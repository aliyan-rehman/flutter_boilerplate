import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/item_model.dart';
import '../../../models/user_model.dart';

class FirestoreService {
  // Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── USER PROFILE ───────────────────────────────────────

  // Save user to Firestore after login
  Future<void> saveUser(UserModel user) async {
    try {
      await _db
          .collection('users')     // 'users' collection
          .doc(user.uid)           // document ID = user's uid
          .set(user.toMap());      // convert UserModel → Map and save
    } catch (e) {
      print('Save User Error: $e');
    }
  }

  // Get user from Firestore
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
      await _db.collection('users').doc(uid).get();

      if (doc.exists) {
        // Convert Map → UserModel using fromMap
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Get User Error: $e');
      return null;
    }
  }

  // ─── ITEMS CRUD ──────────────────────────────────────────

  // ADD item to Firestore
  Future<void> addItem(ItemModel item) async {
    try {
      await _db
          .collection('items')
          .add(item.toMap()); // Firestore auto generates document ID
    } catch (e) {
      print('Add Item Error: $e');
    }
  }

  // GET all items from Firestore — returns a live stream (auto updates UI)
  Stream<List<ItemModel>> getItems() {
    return _db.collection('items').snapshots().map((snapshot) {
      // Convert each Firestore document → ItemModel
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id; // add document ID to map
        return ItemModel.fromMap(data);
      }).toList();
    });
  }

  // UPDATE item in Firestore
  Future<void> updateItem(String docId, ItemModel item) async {
    try {
      await _db
          .collection('items')
          .doc(docId)
          .update(item.toMap());
    } catch (e) {
      print('Update Item Error: $e');
    }
  }

  // DELETE item from Firestore
  Future<void> deleteItem(String docId) async {
    try {
      await _db.collection('items').doc(docId).delete();
    } catch (e) {
      print('Delete Item Error: $e');
    }
  }
}