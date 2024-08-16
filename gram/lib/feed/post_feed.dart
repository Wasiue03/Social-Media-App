import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostFeed extends StatefulWidget {
  final List<Map<String, dynamic>> posts;

  PostFeed({required this.posts});

  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  List<Map<String, dynamic>> get posts => widget.posts;

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
          ListView.builder(
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
                        leading: Icon(Icons.account_circle,
                            color: Colors.white, size: 40),
                        title: Text(post['user'],
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(getTimeAgo(postTime),
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
                          null) // Check if image URL or path is provided
                        post['image'].startsWith(
                                'http') // Check if the image is a URL
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
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon:
                                      Icon(Icons.thumb_up, color: Colors.white),
                                  onPressed: () {},
                                ),
                                Text('Like',
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon:
                                      Icon(Icons.comment, color: Colors.white),
                                  onPressed: () {},
                                ),
                                Text('Comment',
                                    style: TextStyle(color: Colors.white)),
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
