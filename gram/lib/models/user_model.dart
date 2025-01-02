class UserModel {
  String uid;
  String email;
  String username;
  String profileImage;
  List<PostModel> posts; // List to hold posts created by the user

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.profileImage,
    required this.posts, // Initialize posts with an empty list or real data
  });

  // Method to convert UserModel to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'profileImage': profileImage,
      'posts': posts
          .map((post) => post.toMap())
          .toList(), // Convert posts list to map
    };
  }

  // Method to create a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      profileImage: map['profileImage'] ?? '',
      posts:
          (map['posts'] as List?)?.map((e) => PostModel.fromMap(e)).toList() ??
              [],
    );
  }
}

// Model for individual Post
class PostModel {
  String content;
  String image;
  String time;
  String userUid;

  PostModel({
    required this.content,
    required this.image,
    required this.time,
    required this.userUid,
  });

  // Method to convert PostModel to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'image': image,
      'time': time,
      'userUid': userUid,
    };
  }

  // Method to create a PostModel from a map
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      content: map['content'] ?? '',
      image: map['image'] ?? '',
      time: map['time'] ?? '',
      userUid: map['userUid'] ?? '',
    );
  }
}
