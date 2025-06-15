class ReviewModel {
  final String productID;
  final String customerID;
  // final String avatarUrl;
  final String title;
  final String content;
  final int rating;
  final String updatedAt;

  ReviewModel({
    required this.productID,
    required this.customerID,
    required this.title,
    required this.content,
    required this.rating,
    required this.updatedAt,
    // required this.avatarUrl,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    productID: json['productID'] as String,
    customerID: json['customerID'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    rating: json['rating'] as int,
    updatedAt: json['updatedAt'] as String,
  );

  Map<String, dynamic> toJson() => {
    'productID': productID,
    'customerID': customerID,
    'title': title,
    'content': content,
    'rating': rating,
    'updatedAt': updatedAt,
  };
}
