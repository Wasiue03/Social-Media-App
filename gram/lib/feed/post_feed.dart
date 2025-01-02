import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostFeed extends StatefulWidget {
  const PostFeed({super.key});

  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    List<Map<String, dynamic>> fetchedPosts = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> postData = doc.data() as Map<String, dynamic>;
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
      return const CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 20,
        child: Icon(Icons.account_circle, color: Colors.white, size: 40),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Post Feed',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
<<<<<<< HEAD
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.grey.shade800,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_circle,
                            color: Colors.white, size: 40),
                        title: Text(post['user'],
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(getTimeAgo(post['time']),
                            style: TextStyle(color: Colors.white60)),
                        trailing: Icon(Icons.more_vert, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          post['content'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if (post['image'] !=
                          null) 
                        post['image'].startsWith(
                                'http') 
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
=======
          posts.isEmpty
              ? const Center(
                  child: Text(
                    'No posts available',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
>>>>>>> f41f13ea250c2a84334c38ed427ab33e4aefb55e
                          children: [
                            ListTile(
                              leading:
                                  _buildProfileImage(post['userProfileImage']),
                              title: Text(post['userName'] ?? 'Unknown User',
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(getTimeAgo(postTime),
                                  style:
                                      const TextStyle(color: Colors.white60)),
                              trailing: const Icon(Icons.more_vert,
                                  color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                post['content'] ?? '',
                                style: const TextStyle(color: Colors.white),
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
                                        icon: const Icon(Icons.thumb_up,
                                            color: Colors.white),
                                        onPressed: () {},
                                      ),
                                      const Text('Like',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.comment,
                                            color: Colors.white),
                                        onPressed: () {},
                                      ),
                                      const Text('Comment',
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
