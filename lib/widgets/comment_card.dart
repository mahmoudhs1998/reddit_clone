import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/reddit_controller.dart';
import '../models/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final String postId;
  final int depth;
  final RedditController controller = Get.find();

  CommentCard({required this.comment, required this.postId , this.depth = 0});

  @override
  Widget build(BuildContext context) {
    final currentUserId = controller.currentUser.value!.id;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (depth > 0)
            Container(
              width: 24.0 * depth,
              child: VerticalDivider(
                color: Colors.grey,
                thickness: 1,
                indent: 12,
                endIndent: 12,
              ),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: Text('r/${comment.username[0]}'), radius: 12),
                      SizedBox(width: 8),
                      Text('r/${comment.username}' , style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text(timeago.format(comment.createdAt), style: TextStyle(color: Colors.grey)),
                      if (controller.canEditOrDelete(comment.userId))
                        PopupMenuButton<int>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 0,
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Edit Comment'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete Comment'),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 0) {
                              _showEditCommentDialog(context);
                            } else if (value == 1) {
                              controller.deleteComment(comment.id);
                            }
                          },
                        ),

                      if (comment.isOP)
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('OP', style: TextStyle(fontSize: 10)),
                        ),
                    ],
                  ),
                  // Spacer(),



                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(comment.content),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_outward, size: 16, color: comment.isUpvotedByUser(currentUserId) ? Colors.orange : Colors.grey,),
                        onPressed: () => controller.toggleCommentVote(comment.id, true),
                      ),
                      Text(
                        comment.score.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: comment.score > 0 ? Colors.orange : (comment.score < 0 ? Colors.blue : Colors.grey),
                        ),
                      ),
                      // Text(comment.upvotes.toString(), style: TextStyle(fontSize: 12)),
                      IconButton(
                        icon: Icon(Icons.arrow_downward, size: 16, color: comment.isDownvotedByUser(currentUserId) ? Colors.blue : Colors.grey,),
                        onPressed: () => controller.toggleCommentVote(comment.id, false),
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.reply, size: 16),
                        label: Text('Reply', style: TextStyle(fontSize: 12)),
                        onPressed: () => _showReplyDialog(context),
                      ),
                    ],
                  ),
                  ...controller.comments
                      .where((reply) => reply.parentId == comment.id)
                      .map((reply) => CommentCard(comment: reply, postId: postId, depth: depth + 1)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context) {
    final TextEditingController replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reply to comment'),
        content: TextField(
          controller: replyController,
          decoration: InputDecoration(hintText: 'Enter your reply'),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Reply'),
            onPressed: () {
              if (replyController.text.isNotEmpty) {
                controller.addReply(postId, comment.id, replyController.text);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditCommentDialog(BuildContext context) {
    final TextEditingController editController = TextEditingController(text: comment.content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Comment'),
        content: TextField(
          controller: editController,
          decoration: InputDecoration(hintText: 'Enter new content'),
          maxLines: null,
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              if (editController.text.isNotEmpty) {
                controller.editComment(comment.id, editController.text);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }


}