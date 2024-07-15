import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reddit_clone/views/profile_view.dart';

import '../controllers/reddit_controller.dart';
import '../widgets/post_card.dart';

class RedditPostView extends StatelessWidget {
  final RedditController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1B),
        title: Text('Reddit Clone'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddPostDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Get.to(() => ProfileView()),
          ),
        ],
      ),
      body: Obx(() => ListView(
        children: [

          ...controller.posts.map((post) => PostCard(post: post)),
        ],
      )),
    );
  }

  void _showAddPostDialog(BuildContext context) {
    final TextEditingController contentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Post'),
        content: TextField(
          controller: contentController,
          decoration: InputDecoration(hintText: 'Enter your post content'),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Post'),
            onPressed: () {
              if (contentController.text.isNotEmpty) {
                controller.addPost(contentController.text);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
