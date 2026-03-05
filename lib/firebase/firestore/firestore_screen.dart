import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firestore_provider.dart';

class FirestoreScreen extends StatefulWidget {
  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start listening to Firestore when screen opens
    Future.microtask(() =>
        Provider.of<FirestoreProvider>(context, listen: false).listenToItems());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Show bottom sheet to add or edit item
  void _showItemSheet({String? docId, String? existingTitle, String? existingDesc}) {
    // Pre-fill fields if editing
    if (existingTitle != null) _titleController.text = existingTitle;
    if (existingDesc != null) _descController.text = existingDesc;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // allows sheet to grow with keyboard
      builder: (context) {
        final provider = Provider.of<FirestoreProvider>(context);
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                docId == null ? 'Add Item' : 'Edit Item',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 20),
              provider.isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () async {
                  if (docId == null) {
                    // ADD
                    await provider.addItem(
                      _titleController.text.trim(),
                      _descController.text.trim(),
                    );
                  } else {
                    // UPDATE
                    await provider.updateItem(
                      docId,
                      _titleController.text.trim(),
                      _descController.text.trim(),
                    );
                  }
                  _titleController.clear();
                  _descController.clear();
                  Navigator.pop(context); // close sheet
                },
                child: Text(docId == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FirestoreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Items'),
      ),
      // FAB to open add sheet
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _titleController.clear();
          _descController.clear();
          _showItemSheet();
        },
        child: Icon(Icons.add),
      ),
      body: provider.items.isEmpty
          ? Center(child: Text('No items yet. Tap + to add.'))
          : ListView.builder(
        itemCount: provider.items.length,
        itemBuilder: (context, index) {
          final item = provider.items[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.description),
            // Edit button
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _showItemSheet(
                      docId: item.id,
                      existingTitle: item.title,
                      existingDesc: item.description,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteItem(item.id!);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}