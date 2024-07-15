import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/comment.dart';
import '../models/post.dart';
import '../models/user.dart';

class RedditController extends GetxController {
  final SharedPreferences prefs = Get.find<SharedPreferences>();
  var users = <User>[].obs;
  var posts = <Post>[].obs;
  var comments = <Comment>[].obs;
  var currentUser = Rxn<User>();
  // Add a map to track expanded posts
  final expandedPosts = <String, bool>{}.obs;


  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    loadUsers();
    loadPosts();
    loadComments();
  }
  void giveAward(String postId, String awardType) {
    final post = posts.firstWhere((p) => p.id == postId);
    post.awards++;
    // You could implement different award types here if needed
    posts.refresh();
    savePosts();
  }
  void loadUsers() {
    final usersJson = prefs.getString('users');
    if (usersJson != null) {
      final List<dynamic> decodedUsers = json.decode(usersJson);
      users.assignAll(decodedUsers.map((user) => User.fromJson(user)).toList());
    }
  }

  void loadPosts() {
    final postsJson = prefs.getString('posts');
    if (postsJson != null) {
      final List<dynamic> decodedPosts = json.decode(postsJson);
      posts.assignAll(decodedPosts.map((post) => Post.fromJson(post)).toList());
    }
  }

  void loadComments() {
    final commentsJson = prefs.getString('comments');
    if (commentsJson != null) {
      final List<dynamic> decodedComments = json.decode(commentsJson);
      comments.assignAll(decodedComments.map((comment) => Comment.fromJson(comment)).toList());
    }
  }




// Modify upvote and downvote methods

  void toggleVote(String postId, bool isUpvote) {
    final post = posts.firstWhere((p) => p.id == postId);
    final userId = currentUser.value!.id;

    if (isUpvote) {
      if (post.upVotedBy.contains(userId)) {
        // Remove upvote
        post.upVotedBy.remove(userId);
        post.score--;
      } else {
        // Add upvote
        post.upVotedBy.add(userId);
        post.score++;
        // Remove downvote if exists
        if (post.downVotedBy.contains(userId)) {
          post.downVotedBy.remove(userId);
          post.score++;
        }
      }
    } else {
      if (post.downVotedBy.contains(userId)) {
        // Remove downvote
        post.downVotedBy.remove(userId);
        post.score++;
      } else {
        // Add downvote
        post.downVotedBy.add(userId);
        post.score--;
        // Remove upvote if exists
        if (post.upVotedBy.contains(userId)) {
          post.upVotedBy.remove(userId);
          post.score--;
        }
      }
    }
    posts.refresh();
    savePosts();
  }

  void toggleCommentVote(String commentId, bool isUpvote) {
    final comment = comments.firstWhere((c) => c.id == commentId);
    final userId = currentUser.value!.id;

    if (isUpvote) {
      if (comment.upvotedBy.contains(userId)) {
        // Remove upvote
        comment.upvotedBy.remove(userId);
        comment.score--;
      } else {
        // Add upvote
        comment.upvotedBy.add(userId);
        comment.score++;
        // Remove downvote if exists
        if (comment.downvotedBy.contains(userId)) {
          comment.downvotedBy.remove(userId);
          comment.score++;
        }
      }
    } else {
      if (comment.downvotedBy.contains(userId)) {
        // Remove downvote
        comment.downvotedBy.remove(userId);
        comment.score++;
      } else {
        // Add downvote
        comment.downvotedBy.add(userId);
        comment.score--;
        // Remove upvote if exists
        if (comment.upvotedBy.contains(userId)) {
          comment.upvotedBy.remove(userId);
          comment.score--;
        }
      }
    }
    comments.refresh();
    saveComments();
  }

  void toggleExpandPost(String postId) {
    expandedPosts[postId] = !(expandedPosts[postId] ?? false);
  }

  void saveUsers() {
    prefs.setString('users', json.encode(users.map((user) => user.toJson()).toList()));
  }

  void addReply(String postId, String? parentCommentId, String content) {
    final post = posts.firstWhere((p) => p.id == postId);
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: postId,
      userId: currentUser.value!.id,
      username: currentUser.value!.username,
      createdAt: DateTime.now(),
      content: content,
      upvotes: 0,
      isOP: currentUser.value!.id == post.userId,  // Set isOP based on whether the replier is the original poster
      parentId: parentCommentId,
    );
    comments.add(newComment);
    post.commentCount++;
    comments.refresh();
    posts.refresh();
    saveComments();
    savePosts();
  }
  void savePosts() {
    prefs.setString('posts', json.encode(posts.map((post) => post.toJson()).toList()));
  }

  void saveComments() {
    prefs.setString('comments', json.encode(comments.map((comment) => comment.toJson()).toList()));
  }

  bool login(String username, String password) {
    final user = users.firstWhereOrNull((u) => u.username == username && u.password == password);
    if (user != null) {
      currentUser.value = user;
      return true;
    }
    return false;
  }

  void logout() {
    currentUser.value = null;
  }

  void register(String username, String email, String password) {
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      email: email,
      password: password,
    );
    users.add(newUser);
    saveUsers();
  }

  void updateUser(String userId, {String? username, String? email, String? password}) {
    final user = users.firstWhere((u) => u.id == userId);
    if (username != null) user.username = username;
    if (email != null) user.email = email;
    if (password != null) user.password = password;
    users.refresh();
    saveUsers();
  }

  void deleteUser(String userId) {
    users.removeWhere((u) => u.id == userId);
    posts.removeWhere((p) => p.userId == userId);
    comments.removeWhere((c) => c.userId == userId);
    saveUsers();
    savePosts();
    saveComments();
  }
  void addPost(String content) {
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser.value!.id,
      username: currentUser.value!.username,
      createdAt: DateTime.now(),
      content: content,
      upVotes: 0,
      commentCount: 0,
    );
    posts.add(newPost);
    savePosts();
  }
  void addComment(String postId, String content) {
    final post = posts.firstWhere((p) => p.id == postId);
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: postId,
      userId: currentUser.value!.id,
      username: currentUser.value!.username,
      createdAt: DateTime.now(),
      content: content,
      upvotes: 0,
      isOP: currentUser.value!.id == post.userId,  // Set isOP based on whether the commenter is the original poster
    );
    comments.add(newComment);
    post.commentCount++;
    saveComments();
    savePosts();
  }

  bool canEditOrDelete(String contentUserId) {
    return currentUser.value != null && currentUser.value!.id == contentUserId;
  }

  void editPost(String postId, String newContent) {
    final post = posts.firstWhere((p) => p.id == postId);
    if (canEditOrDelete(post.userId)) {
      post.content = newContent;
      posts.refresh();
      savePosts();
    } else {
      Get.snackbar('Error', 'You do not have permission to edit this post.');
    }
  }

  void editComment(String commentId, String newContent) {
    final comment = comments.firstWhere((c) => c.id == commentId);
    if (canEditOrDelete(comment.userId)) {
      comment.content = newContent;
      comments.refresh();
      saveComments();
    } else {
      Get.snackbar('Error', 'You do not have permission to edit this comment.');
    }
  }




  void deletePost(String postId) {
    final post = posts.firstWhere((p) => p.id == postId);
    if (canEditOrDelete(post.userId)) {
      posts.removeWhere((p) => p.id == postId);
      comments.removeWhere((c) => c.postId == postId);
      savePosts();
      saveComments();
    } else {
      Get.snackbar('Error', 'You do not have permission to delete this post.');
    }
  }


  void deleteComment(String commentId) {
    final comment = comments.firstWhere((c) => c.id == commentId);
    if (canEditOrDelete(comment.userId)) {
      comments.removeWhere((c) => c.id == commentId);
      final post = posts.firstWhere((p) => p.id == comment.postId);
      post.commentCount--;
      saveComments();
      savePosts();
    } else {
      Get.snackbar('Error', 'You do not have permission to delete this comment.');
    }
  }
  void updateComment(String commentId, String newContent) {
    final comment = comments.firstWhere((c) => c.id == commentId);
    comment.content = newContent;
    saveComments();
  }



  void upvotePost(String postId) {
    final post = posts.firstWhere((p) => p.id == postId);
    post.isUpVoted = !post.isUpVoted;
    post.isDownVoted = false;
    post.upVotes += post.isUpVoted ? 1 : -1;
    posts.refresh();
    savePosts();
  }

  void downvotePost(String postId) {
    final post = posts.firstWhere((p) => p.id == postId);
    post.isDownVoted = !post.isDownVoted;
    post.isUpVoted = false;
    post.upVotes -= post.isDownVoted ? 1 : -1;
    posts.refresh();
    savePosts();
  }

  void upvoteComment(String commentId) {
    final comment = comments.firstWhere((c) => c.id == commentId);
    comment.isUpvoted = !comment.isUpvoted;
    comment.isDownvoted = false;
    comment.upvotes += comment.isUpvoted ? 1 : -1;
    comments.refresh();
    saveComments();
  }

  void downvoteComment(String commentId) {
    final comment = comments.firstWhere((c) => c.id == commentId);
    comment.isDownvoted = !comment.isDownvoted;
    comment.isUpvoted = false;
    comment.upvotes -= comment.isDownvoted ? 1 : -1;
    comments.refresh();
    saveComments();
  }
}
