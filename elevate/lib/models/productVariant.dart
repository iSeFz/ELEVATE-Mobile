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

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
    colors: List<String>.from(json['colors'] as List<dynamic>),
    discount: (json['discount'] as num).toDouble(),
    images: List<String>.from(json['images'] as List<dynamic>),
    price: (json['price'] as num).toDouble(),
    size: json['size'] as String,
    stock: json['stock'] as int,
  );

  Map<String, dynamic> toJson() => {
    'colors': colors,
    'discount': discount,
    'images': images,
    'price': price,
    'size': size,
    'stock': stock,
  };
}
