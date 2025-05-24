import 'package:elevate/models/productVariant.dart';
import 'package:elevate/models/review.dart';

class Product {
  final String image;
  final String name;
  final String brand;
  final String category;
  final String department;
  final String description;
  final String material;
  final double averageRating;
  final List<ProductVariant> variants;
  final List<Review> totalReviews;


  // Constructor
  Product({
    required this.image,
    required this.name,
    required this.brand,
    required this.category,
    required this.department,
    required this.description,
    required this.material,
    required this.averageRating,
    required this.totalReviews,
    required this.variants,
  });
}
