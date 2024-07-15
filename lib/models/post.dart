class Post {
  final String id;
  final String userId;
  final String username;
  final DateTime createdAt;
  String content;
  int upVotes;
  int commentCount;
  bool isUpVoted;
  bool isDownVoted;
  final String? videoAssetPath;
  Set<String> upVotedBy;
  Set<String> downVotedBy;
  int score;
  int awards;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.createdAt,
    required this.content,
    required this.upVotes,
    required this.commentCount,
    this.isUpVoted = false,
    this.isDownVoted = false,
    this.videoAssetPath,
    this.score = 0,
    Set<String>? upVotedBy,
    Set<String>? downVotedBy,
    this.awards = 0,
  }):
        this.upVotedBy = upVotedBy ?? {},
        this.downVotedBy = downVotedBy ?? {};

  bool isUpVotedByUser(String userId) => upVotedBy.contains(userId);
  bool isDownVotedByUser(String userId) => downVotedBy.contains(userId);

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'username': username,
    'createdAt': createdAt.toIso8601String(),
    'content': content,
    'upVotes': upVotes,
    'commentCount': commentCount,
    'isUpVoted': isUpVoted,
    'isDownVoted': isDownVoted,
    'awards': awards,
  };

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'],
    userId: json['userId'],
    username: json['username'],
    createdAt: DateTime.parse(json['createdAt']),
    content: json['content'],
    upVotes: json['upVotes'],
    commentCount: json['commentCount'],
    isUpVoted: json['isUpVoted'],
    isDownVoted: json['isDownVoted'],
    awards: json['awards']??0,

  );
}