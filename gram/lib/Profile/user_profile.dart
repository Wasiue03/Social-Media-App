import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading profile",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "Profile not found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image with a better style
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: userData['profileImage'] != ''
                        ? NetworkImage(userData['profileImage'])
                        : null,
                    child: userData['profileImage'] == ''
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                // Username and email
                Center(
                  child: Text(
                    "${userData['username']}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "${userData['email']}",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Joined: ${userData['createdAt'] != null ? userData['createdAt'].toDate().toString() : 'N/A'}",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                // Displaying the posts created by the current user
                const Text(
                  "Your Posts:",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where('userUid',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .orderBy('time',
                            descending: true) // Sorting by latest time
                        .snapshots(),
                    builder: (context, postSnapshot) {
                      if (postSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (postSnapshot.hasError) {
                        return const Center(
                          child: Text(
                            "Error loading posts",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      if (postSnapshot.data == null ||
                          postSnapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "No posts available",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: postSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var post = postSnapshot.data!.docs[index].data()
                              as Map<String, dynamic>;

                          return Card(
                            color: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 5,
                            shadowColor: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Post Content
                                  Text(
                                    post['content'],
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  // Post Image
                                  post['image'] != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            post['image'],
                                            fit: BoxFit.cover,
                                            height: 80,
                                            width: double.infinity,
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(height: 8),
                                  // Time (formatted)
                                  Text(
                                    'Posted on: ${post['time'].toDate().toString()}',
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
