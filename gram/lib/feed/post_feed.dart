import 'package:flutter/material.dart';

class PostFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
          itemCount: 5, // Replace with the actual number of posts
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.grey.shade800,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/profiles/profile${index}.jpeg'),
                      ),
                      title: Text('User ${index}',
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text('2 hours ago',
                          style: TextStyle(color: Colors.white60)),
                      trailing: Icon(Icons.more_vert, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'This is a sample post content for post ${index}.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Image.asset('assets/images/content/cont${index}.jpeg',
                        fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up, color: Colors.white),
                                onPressed: () {},
                              ),
                              Text('Like',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.comment, color: Colors.white),
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
    );
  }
}
