import 'dart:convert';
import 'package:elevate/core/constants/constants.dart';
import 'package:http/http.dart' as http;
import '../models/product_card_model.dart';
import '../models/product_details_model.dart';
import '../models/review_model.dart';

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

  static Future<void> createProductReview(ReviewModel review) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseURL/v1/products/${review.productId}/reviews?userId=${review.customerId}'),
        headers: {
          'Content-Type': 'application/json',
          testAuthHeader: testAuthValue,
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
