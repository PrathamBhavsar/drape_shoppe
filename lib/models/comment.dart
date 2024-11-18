
class CommentModel {
  final String user;
  final String comment;

  CommentModel({
    required this.user,
    required this.comment,
  });

  // // JSON to TaskModel object
  // factory CommentModel.fromJson(Map<String, dynamic> json) {
  //   return CommentModel(
  //     commentId: json['commentId'] as int,
  //     user: json['user'] as String,
  //     createdAt: (json['created_at'] as Timestamp).toDate(),
  //     comment: json['comment'] as String,
  //   );
  // }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        user: json['user'] as String,
        comment: json['comment'] as String);
  }

  // TaskModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'comment': comment,
    };
  }
}
