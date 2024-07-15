import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/reddit_controller.dart';

class AddCommentField extends StatelessWidget {
  final String postId;
  final RedditController controller = Get.find();
  final TextEditingController commentController = TextEditingController();

  AddCommentField({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        controller: commentController,
        decoration: InputDecoration(
          hintText: 'Add a comment',
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                controller.addReply(postId, null, commentController.text);
                commentController.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}
