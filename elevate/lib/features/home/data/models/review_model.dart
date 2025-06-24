class ReviewModel {
  final String productId;
  final String customerId;
  final String customerFirstName;
  final String customerLastName;
  final String customerImageURL;

  final String title;
  final String content;
  final int rating;
  // final String updatedAt;

  ReviewModel({
    required this.productId,
    required this.customerId,
    required this.customerFirstName,
    required this.customerLastName,
    required this.customerImageURL,
    required this.title,
    required this.content,
    required this.rating,
    // required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    productId: json['productId'] as String,
    customerId: json['customerId'] as String,
    customerFirstName: json['customerFirstName'] as String,
    customerLastName: json['customerLastName'] as String,
    customerImageURL: json['customerImageURL'] as String? ?? 'https://pixabay.com/vectors/blank-profile-picture-mystery-man-973460/',

    title: json['title'] as String,
    content: json['content'] as String,
    rating: json['rating'] as int,
    // updatedAt: json['updatedAt'] as String,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'customerId': customerId,
    'title': title,
    'content': content,
    'rating': rating,
    // 'updatedAt': updatedAt,
  };
}
