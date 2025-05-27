class Review {
  final String productID;
  final String customerID;
  final String title;
  final String content;
  final int rating;
  final String updatedAt;

  Review({
    required this.productID,
    required this.customerID,
    required this.title,
    required this.content,
    required this.rating,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
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
