// Model class for the item object
class CartItem {
  String image;
  String name;
  String brand;
  double price;
  String size;
  int quantity;
  List<String> colors;

  // Default constructor
  CartItem({
    required this.image,
    required this.name,
    required this.brand,
    required this.price,
    required this.size,
    required this.quantity,
    required this.colors,
  });
}