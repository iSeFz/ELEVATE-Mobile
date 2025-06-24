import 'dart:convert';
import 'package:elevate/features/home/data/models/review_model.dart';
import 'package:http/http.dart' as http;

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




}
