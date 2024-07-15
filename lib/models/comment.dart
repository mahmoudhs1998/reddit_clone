class Comment {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final DateTime createdAt;
  String content;
  final bool isOP;
  int score;
  int upvotes;
  bool isUpvoted;
  bool isDownvoted;
  Set<String> upvotedBy;
  Set<String> downvotedBy;
  final String? parentId;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.createdAt,
    required this.content,
    this.isOP = false,
    this.score = 0,
    required this.upvotes,
    this.isUpvoted = false,
    this.isDownvoted = false,
    this.parentId,
    Set<String>? upvotedBy,
    Set<String>? downvotedBy,
  }):
        this.upvotedBy = upvotedBy ?? {},
        this.downvotedBy = downvotedBy ?? {};
  bool isUpvotedByUser(String userId) => upvotedBy.contains(userId);
  bool isDownvotedByUser(String userId) => downvotedBy.contains(userId);

  Map<String, dynamic> toJson() => {
    'id': id,
    'postId': postId,
    'userId': userId,
    'username': username,
    'createdAt': createdAt.toIso8601String(),
    'content': content,
    'isOP': isOP,
    'upvotes': upvotes,
    'isUpvoted': isUpvoted,
    'isDownvoted': isDownvoted,
    'parentId': parentId,
  };

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'],
    postId: json['postId'],
    userId: json['userId'],
    username: json['username'],
    createdAt: DateTime.parse(json['createdAt']),
    content: json['content'],
    isOP: json['isOP'],
    upvotes: json['upvotes'],
    isUpvoted: json['isUpvoted'],
    isDownvoted: json['isDownvoted'],
    parentId: json['parentId'],
  );
}