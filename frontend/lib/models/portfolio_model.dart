class PortfolioModel {
  int id;
  String title;
  String description;
  String technologiesUsed;
  String githubLink;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  PortfolioModel({
    required this.id,
    required this.title,
    required this.description,
    required this.technologiesUsed,
    required this.githubLink,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) => PortfolioModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    technologiesUsed: json["technologiesUsed"],
    githubLink: json["githubLink"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    userId: json["UserId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "technologiesUsed": technologiesUsed,
    "githubLink": githubLink,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "UserId": userId,
  };
}

class EditPortfolioModel {
  String title;
  String description;
  String technologiesUsed;
  String githubLink;

  EditPortfolioModel({
    required this.title,
    required this.description,
    required this.technologiesUsed,
    required this.githubLink,
  });

  factory EditPortfolioModel.fromJson(Map<String, dynamic> json) => EditPortfolioModel(
    title: json["title"],
    description: json["description"],
    technologiesUsed: json["technologiesUsed"],
    githubLink: json["githubLink"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "technologiesUsed": technologiesUsed,
    "githubLink": githubLink,
  };
}
