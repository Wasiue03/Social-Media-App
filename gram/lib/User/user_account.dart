import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gram/models/user_model.dart';

class UserAccountScreen extends StatelessWidget {
  final String userUid;

  // Constructor to pass the user's UID
  const UserAccountScreen({super.key, required this.userUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Center(
            child: Text('User Account', style: TextStyle(color: Colors.white))),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userUid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          }

          // Retrieve user data
          var userData = snapshot.data!.data() as Map<String, dynamic>;

          UserModel user = UserModel.fromMap(userData);

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.profileImage.isEmpty
                            ? 'https://www.example.com/default_profile_image.png' // Default profile image URL
                            : user.profileImage),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.username,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bio goes here...', // You can add a bio field in UserModel if needed
                        style: TextStyle(color: Colors.white60),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white54),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userUid)
                      .collection('posts')
                      .get(),
                  builder: (context, postSnapshot) {
                    if (postSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (postSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${postSnapshot.error}'));
                    }

                    if (!postSnapshot.hasData ||
                        postSnapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No posts yet.'));
                    }

                    List<PostModel> posts = postSnapshot.data!.docs.map((doc) {
                      return PostModel.fromMap(
                          doc.data() as Map<String, dynamic>);
                    }).toList();

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey.shade800,
                          child: Image.network(posts[index].image,
                              fit: BoxFit.cover),
                        );
                      },
                    );
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
