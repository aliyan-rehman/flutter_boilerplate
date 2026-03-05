class ItemModel {
  final dynamic id;           // SQLite auto generates this ID
  // before saving, item has no ID yet
  final String title;      // Item title
  final String description;// Item description

  // Constructor
  ItemModel({
    this.id,               // Not required — SQLite assigns it automatically
    required this.title,
    required this.description,
  });

  // fromMap — converts SQLite row or Firestore doc (Map) → ItemModel object
  // Used when READING data
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  // toMap — converts ItemModel object → Map
  // Used when SAVING data
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}