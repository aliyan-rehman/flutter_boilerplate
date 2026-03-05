import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sqlite_provider.dart';

class SqliteScreen extends StatefulWidget {
  @override
  State<SqliteScreen> createState() => _SqliteScreenState();
}

class _SqliteScreenState extends State<SqliteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load items when screen opens
    Future.microtask(() =>
        Provider.of<SqliteProvider>(context, listen: false).loadItems());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showItemSheet({int? id, String? existingTitle, String? existingDesc}) {
    // Pre fill if editing
    _titleController.text = existingTitle ?? '';
    _descController.text = existingDesc ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final provider = Provider.of<SqliteProvider>(context, listen: false);
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
                id == null ? 'Add Item' : 'Edit Item',
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
              ElevatedButton(
                onPressed: () async {
                  String title = _titleController.text.trim();
                  String desc = _descController.text.trim();

                  if (title.isEmpty || desc.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  Navigator.pop(context); // close sheet first

                  if (id == null) {
                    await provider.addItem(title, desc);
                  } else {
                    await provider.updateItem(id, title, desc);
                  }

                  _titleController.clear();
                  _descController.clear();
                },
                child: Text(id == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SqliteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('SQLite Items'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemSheet(),
        child: Icon(Icons.add),
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.items.isEmpty
          ? Center(child: Text('No items yet. Tap + to add.'))
          : ListView.builder(
        itemCount: provider.items.length,
        itemBuilder: (context, index) {
          final item = provider.items[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _showItemSheet(
                      id: item.id,
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