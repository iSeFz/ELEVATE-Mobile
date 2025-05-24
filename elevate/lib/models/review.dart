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
}
