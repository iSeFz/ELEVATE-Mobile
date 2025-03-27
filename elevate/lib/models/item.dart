// Model class for the item object
class Item {
  String image;
  String name;
  String brand;
  double price;
  String size;
  int quantity;
  List<String> colors;

  // Default constructor
  Item({
    required this.image,
    required this.name,
    required this.brand,
    required this.price,
    required this.size,
    required this.quantity,
    required this.colors,
  });
}