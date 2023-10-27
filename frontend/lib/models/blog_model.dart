class BlogModel {
  int id;
  String title;
  String content;
  String imageUrl;
  String category;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  BlogModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    imageUrl: json["imageUrl"],
    category: json["category"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    userId: json["UserId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "imageUrl": imageUrl,
    "category": category,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "UserId": userId,
  };
}
class AddBlogModel {
  String title;
  String content;
  String imageUrl;
  String category;

  AddBlogModel({
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
  });

  factory AddBlogModel.fromJson(Map<String, dynamic> json) => AddBlogModel(
    title: json["title"],
    content: json["content"],
    imageUrl: json["imageUrl"],
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
    "imageUrl": imageUrl,
    "category": category,
  };
}
