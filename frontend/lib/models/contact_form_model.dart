class ContactFormModel {
  String title;
  String description;
  String senderName;
  String receiverName;
  String receiverEmail;

  ContactFormModel({
    required this.title,
    required this.description,
    required this.senderName,
    required this.receiverName,
    required this.receiverEmail,
  });

  factory ContactFormModel.fromJson(Map<String, dynamic> json) => ContactFormModel(
    title: json["title"],
    description: json["description"],
    senderName: json["senderName"],
    receiverName: json["receiverName"],
    receiverEmail: json["receiverEmail"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "senderName": senderName,
    "receiverName": receiverName,
    "receiverEmail":receiverEmail,
  };
}
