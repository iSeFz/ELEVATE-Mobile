class CartItem {
  String? id;
  String productId;
  String variantId;
  int quantity;
  String brandName;
  String productName;
  String size; 
  String color;
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
    required this.color,
    required this.price,
    required this.imageURL,
  });
}
