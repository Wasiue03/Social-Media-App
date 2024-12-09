import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostFeed extends StatefulWidget {
  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  List<Map<String, dynamic>> posts = [];
  String? userUid; // Store current user UID

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // Fetch the current user UID
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userUid = user.uid;
      });
      print('Logged-in User UID: $userUid');
      print('Logged-in User Email: ${user.email}');
      print('Logged-in Username: ${user.displayName}');
      await _fetchPosts();
    } else {
      print('No user logged in');
    }
  }

  // Fetch posts only for the logged-in user
  Future<void> _fetchPosts() async {
    if (userUid == null) {
      print('User UID is null');
      return;
    }

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('userUid', isEqualTo: userUid) // Match the correct field
        .get();

    print('Number of posts fetched: ${snapshot.docs.length}');

    List<Map<String, dynamic>> fetchedPosts = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> postData = doc.data() as Map<String, dynamic>;
      print('Fetched Post: $postData');
      fetchedPosts.add(postData);
    }

    setState(() {
      posts = fetchedPosts;
    });
  }

  String getTimeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  Widget _buildProfileImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 20,
      );
    } else {
      return CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.account_circle, color: Colors.white, size: 40),
        radius: 20,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Post Feed',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          posts.isEmpty
              ? Center(
                  child: Text(
                    'No posts available',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    DateTime postTime;

                    if (post['time'] is Timestamp) {
                      postTime = (post['time'] as Timestamp).toDate();
                    } else if (post['time'] is DateTime) {
                      postTime = post['time'];
                    } else {
                      postTime = DateTime.now(); // Fallback to current time
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.grey.shade800,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading:
                                  _buildProfileImage(post['userProfileImage']),
                              title: Text(post['userName'] ?? 'Unknown User',
                                  style: TextStyle(color: Colors.white)),
                              subtitle: Text(getTimeAgo(postTime),
                                  style: TextStyle(color: Colors.white60)),
                              trailing:
                                  Icon(Icons.more_vert, color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                post['content'] ?? '',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            if (post['image'] != null)
                              post['image'].startsWith('http')
                                  ? Image.network(
                                      post['image'],
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
                                    )
                                  : Image.file(
                                      File(post['image']),
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
                                    ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.thumb_up,
                                            color: Colors.white),
                                        onPressed: () {},
                                      ),
                                      Text('Like',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.comment,
                                            color: Colors.white),
                                        onPressed: () {},
                                      ),
                                      Text('Comment',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
