class UserModel {
  String uid;
  String email;

  UserModel({required this.uid, required this.email});

  // Method to convert UserModel to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  // Method to create a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
