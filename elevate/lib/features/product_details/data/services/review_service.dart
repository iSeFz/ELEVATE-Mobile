import 'dart:convert';
import 'package:elevate/features/product_details/data/models/review_model.dart';
import 'package:elevate/features/product_details/presentation/screens/product_details_page.dart';
import 'package:http/http.dart' as http;
import '../models/product_card_model.dart';
import '../models/product_details_model.dart';

class ReviewService {
  static String baseUrl = "https://elevate-gp.vercel.app/api/v1/";

  // ProductService({required this.baseUrl});

  static Future<List<ReviewModel>> getProductReviews(String productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$productId/reviews'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> reviewsJson = jsonResponse['data'] ?? [];

      return reviewsJson.map((json) => ReviewModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load product reviews');
    }
  }

  static Future<void> createProductReview(ReviewModel review, String productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/${productId}/reviews'),
        headers: {
          'Content-Type': 'application/json',
          'productId': review.productId!, // if your backend expects this in header
        },
        body: jsonEncode(review.toJson()),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode != 201) {
        throw Exception('Failed to create review: ${response.body}  ${review.productId}');
      }
    } catch (e) {
      print('Error in createProductReview: $e');
      rethrow;
    }
  }



}
