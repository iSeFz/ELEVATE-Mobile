class CartItem {
  String? id;
  String productId;
  String variantId;
  int quantity;
  String brandName;
  String productName;
  String size;
  List<String> colors;
  double price;
  String imageURL;

  CartItem({
    this.id,
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.brandName,
    required this.productName,
    required this.size,
    required this.colors,
    required this.price,
    required this.imageURL,
  });
}
