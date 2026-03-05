class UserModel {
  // These are the fields — data we want to store about a user
  final String uid;        // Unique ID Firebase gives every user
  final String name;       // User's display name
  final String email;      // User's email
  final String? photoUrl;  // Profile photo — nullable (?) because maybe user has no photo

  // Constructor — used to create a UserModel object
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,         // Not required because it can be null
  });

  // fromMap — converts Firebase/Firestore data (Map) → UserModel object
  // Used when READING data from Firebase
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',        // if uid is null, use empty string
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],    // can stay null, that's fine
    );
  }

  // toMap — converts UserModel object → Map
  // Used when SAVING data to Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}