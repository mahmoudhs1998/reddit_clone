import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/reddit_controller.dart';
import '../models/post.dart';
import 'add_comment_field.dart';
import 'award_button.dart';
import 'comment_card.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final RedditController controller = Get.find();

  PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final currentUserId = controller.currentUser.value!.id;

    return Obx(() => Card(
      color: const Color(0xFF2D2D2E),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(child: Text(post.username[0])),
            title: Text(
                'r/${post.username}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(timeago.format(post.createdAt), style: const TextStyle(color: Colors.grey)),
            trailing: controller.canEditOrDelete(post.userId)
                ? PopupMenuButton<int>(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Edit Post'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete Post'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 0) {
                  _showEditPostDialog(context);
                } else if (value == 1) {
                  controller.deletePost(post.id);
                }
              },
            )
                : null,
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.content.isNotEmpty)
                  Text(post.content),
                const SizedBox(height: 8),

                if (post.videoAssetPath != null)
                  Chewie(
                    controller: ChewieController(
                      videoPlayerController: VideoPlayerController.networkUrl (
                        Uri(path:'assets/videos/v.mp4'), // Adjust with correct path or URL
                      ),
                      aspectRatio: 16 / 9, // Adjust as per your video's aspect ratio
                      autoInitialize: true,
                      looping: true,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_upward, color: post.isUpVotedByUser(currentUserId) ? Colors.orange : Colors.grey,),
                      onPressed: () => controller.toggleVote(post.id, true),
                    ),
                    Text(
                      post.score.toString(),
                      style: TextStyle(
                        color: post.score > 0 ? Colors.orange : (post.score < 0 ? Colors.blue : Colors.grey),
                      ),
                    ),
                    // Text(post.upvotes.toString()),
                    IconButton(
                      icon: Icon(Icons.arrow_downward, color: post.isDownVotedByUser(currentUserId) ? Colors.blue : Colors.grey,),
                      onPressed: () => controller.toggleVote(post.id, false),
                    ),
                    const Spacer(),
                    AwardButton(
                      onPressed: () => _showAwardDialog(context),
                      awardCount: post.awards,
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.comment),
                      label: Text('${post.commentCount} comments'),
                      onPressed: () => controller.toggleExpandPost(post.id),
                    ),
                  ],
                ),
                if (controller.expandedPosts[post.id] ?? false)
                  Column(
                    children: [
                      ...controller.comments
                          .where((comment) => comment.postId == post.id && comment.parentId == null)
                          .map((comment) => CommentCard(comment: comment, postId: post.id)),
                      AddCommentField(postId: post.id),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
  void _showEditPostDialog(BuildContext context) {
    final TextEditingController editController = TextEditingController(text: post.content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Post'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(hintText: 'Enter new content'),
          maxLines: null,
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              if (editController.text.isNotEmpty) {
                controller.editPost(post.id, editController.text);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
  void _showAwardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Give an Award'),
        content: const Text('Choose an award to give to this post:'),
        actions: [
          TextButton(
            child: const Text('Silver'),
            onPressed: () {
              controller.giveAward(post.id, 'silver');
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Gold'),
            onPressed: () {
              controller.giveAward(post.id, 'gold');
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Platinum'),
            onPressed: () {
              controller.giveAward(post.id, 'platinum');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

}
