import 'package:elevate/models/productVariant.dart';
import 'package:elevate/models/review.dart';

class Product {
  final String brandId;
  final String brandName;
  final String brandOwnerId;
  final int brandSubscriptionPlan;
  final String category;
  final String description;
  final String material;
  final String name;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  final List<ProductVariant> variants;

  // Derived attributes
  final String color;
  final double price;
  final String image;

  Product({
    required this.brandId,
    required this.brandName,
    required this.brandOwnerId,
    required this.brandSubscriptionPlan,
    required this.category,
    required this.description,
    required this.material,
    required this.name,
    // required this.createdAt,
    // required this.updatedAt,
    required this.variants,
    required this.color,
    required this.price,
    required this.image,

  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final variantList = (json['variants'] as List)
        .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
        .toList();

    final firstVariant = variantList.isNotEmpty ? variantList.first : null;

    return Product(
      brandId: json['brandId'] as String,
      brandName: json['brandName'] as String,
      brandOwnerId: json['brandOwnerId'] as String,
      brandSubscriptionPlan: json['brandSubscriptionPlan'] as int,
      category: json['category'] as String,
      description: json['description'] as String,
      material: json['material'] as String,
      name: json['name'] as String,
      // createdAt: DateTime.fromMillisecondsSinceEpoch(
      //   (json['createdAt']['_seconds'] * 1000),
      // ),
      // updatedAt: DateTime.fromMillisecondsSinceEpoch(
      //   (json['updatedAt']['_seconds'] * 1000),
      // ),
      variants: variantList,
      color: firstVariant?.colors.first ?? '',
      price: firstVariant?.price ?? 0.0,
      image: firstVariant?.images.first ??
      'https://domanza.co/cdn/shop/files/CCxNavy-45Large_27baa9f2-e314-4ffb-a8a9-65d1ad738bc8_jpg.jpg?v=1739309915&width=5760',
    );
  }
}

