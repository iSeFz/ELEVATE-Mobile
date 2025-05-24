import 'package:elevate/models/productVariant.dart';
import 'package:elevate/models/review.dart';

class Product {
  final String brandId;
  final String brandName;
  final String brandOwnerId;
  final int brandSubscriptionPlan;
  final String category;
  // final DateTime createdAt;
  final String description;
  final String material;
  final String name;
  // final DateTime updatedAt;
  // final List<ProductVariant> variants;
  // final List<Review> totalReviews; // Keep this if your JSON has it

  Product({
    required this.brandId,
    required this.brandName,
    required this.brandOwnerId,
    required this.brandSubscriptionPlan,
    required this.category,
    // required this.createdAt,
    required this.description,
    required this.material,
    required this.name,
    // required this.updatedAt,
    // required this.variants,
    // required this.totalReviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    brandId: json['brandId'] as String,
    brandName: json['brandName'] as String,
    brandOwnerId: json['brandOwnerId'] as String,
    brandSubscriptionPlan: json['brandSubscriptionPlan'] as int,
    category: json['category'] as String,
    // createdAt: DateTime.parse(json['createdAt'] as String),
    description: json['description'] as String,
    material: json['material'] as String,
    name: json['name'] as String,
    // updatedAt: DateTime.parse(json['updatedAt'] as String),
    // variants: (json['variants'] as List<dynamic>)
    //     .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
    //     .toList(),
    // totalReviews: json['totalReviews'] != null
    //     ? (json['totalReviews'] as List<dynamic>)
    //     .map((e) => Review.fromJson(e as Map<String, dynamic>))
    //     .toList()
    //     : [],
  );

  Map<String, dynamic> toJson() => {
    'brandId': brandId,
    'brandName': brandName,
    'brandOwnerId': brandOwnerId,
    'brandSubscriptionPlan': brandSubscriptionPlan,
    'category': category,
    // 'createdAt': createdAt.toIso8601String(),
    'description': description,
    'material': material,
    'name': name,
    // 'updatedAt': updatedAt.toIso8601String(),
    // 'variants': variants.map((e) => e.toJson()).toList(),
    // 'totalReviews': totalReviews.map((e) => e.toJson()).toList(),
  };
}
