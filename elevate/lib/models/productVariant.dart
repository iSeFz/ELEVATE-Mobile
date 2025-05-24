class ProductVariant {
  final List<String> colors;
  final double discount;
  final List<String> images;
  final double price;
  final String size;
  final int stock;

  ProductVariant({
    required this.colors,
    required this.discount,
    required this.images,
    required this.price,
    required this.size,
    required this.stock,
  });
}
