class WishlistProduct {
  final String productId;
  final String brandName;
  final String name;
  final String imageURL;
  final int price;

  WishlistProduct({
    required this.productId,
    required this.brandName,
    required this.name,
    required this.imageURL,
    required this.price,
  });

  factory WishlistProduct.fromJson(Map<String, dynamic> json) {
    return WishlistProduct(
      productId: json['productId'] ?? '',
      brandName: json['brandName'] ?? '',
      name: json['name'] ?? '',
      imageURL: json['imageURL'] ?? '',
      price: json['price'] ?? 0,
    );
  }
}
