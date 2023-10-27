class CommentModel {
  int id;
  String content;
  int blogId;
  int userId;
  DateTime updatedAt;
  DateTime createdAt;

  CommentModel({
    required this.id,
    required this.content,
    required this.blogId,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    id: json["id"],
    content: json["content"],
    blogId: json["BlogId"],
    userId: json["UserId"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "BlogId": blogId,
    "UserId": userId,
    "updatedAt": updatedAt.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
  };
}
