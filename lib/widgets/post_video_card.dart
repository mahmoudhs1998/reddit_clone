// //##################################  with video ###########################################
//
// class PostCardVideo extends StatefulWidget {
//   final Post post;
//
//   PostCardVideo({required this.post});
//
//   @override
//   _PostCardVideoState createState() => _PostCardVideoState();
// }
//
// class _PostCardVideoState extends State<PostCardVideo> {
//   final RedditController controller = Get.find();
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }
//
//   void _initializePlayer() {
//     _videoPlayerController = VideoPlayerController.asset(widget.post.videoAssetPath ?? 'assets/videos/v.mp4')
//       ..initialize().then((_) {
//         setState(() {
//           _chewieController = ChewieController(
//             videoPlayerController: _videoPlayerController,
//             autoInitialize: true,
//             looping: false,
//             aspectRatio: 16 / 9,
//             autoPlay: false,
//           );
//         });
//       });
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Card(
//       color: Color(0xFF2D2D2E),
//       margin: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             leading: CircleAvatar(child: Text(widget.post.username[0])),
//             title: Text(widget.post.username, style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text(widget.post.createdAt.toString(), style: TextStyle(color: Colors.grey)),
//             trailing: Icon(Icons.more_vert),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (widget.post.content.isNotEmpty)
//                   Text(widget.post.content),
//                 SizedBox(height: 8),
//                 if (_chewieController != null)
//                   AspectRatio(
//                     aspectRatio: 16 / 9,
//                     child: Chewie(controller: _chewieController!),
//                   ),
//                 SizedBox(height: 8),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.arrow_upward, color: widget.post.isUpvoted ? Colors.orange : Colors.grey),
//                       onPressed: () => controller.toggleVote(widget.post.id, true),
//                     ),
//                     Text(widget.post.upvotes.toString()),
//                     IconButton(
//                       icon: Icon(Icons.arrow_downward, color: widget.post.isDownvoted ? Colors.blue : Colors.grey),
//                       onPressed: () => controller.toggleVote(widget.post.id, false),
//                     ),
//                     Spacer(),
//                     TextButton.icon(
//                       icon: Icon(Icons.comment),
//                       label: Text('${widget.post.commentCount} comments'),
//                       onPressed: () => controller.toggleExpandPost(widget.post.id),
//                     ),
//                   ],
//                 ),
//                 if (controller.expandedPosts[widget.post.id] ?? false)
//                   Column(
//                     children: [
//                       ...controller.comments
//                           .where((comment) => comment.postId == widget.post.id && comment.parentId == null)
//                           .map((comment) => CommentCard(comment: comment, postId: widget.post.id)),
//                       AddCommentField(postId: widget.post.id),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }
//
//
// //##################################  with video ###########################################