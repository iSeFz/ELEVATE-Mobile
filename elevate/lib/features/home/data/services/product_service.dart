import 'dart:convert';
import 'package:elevate/features/home/data/models/review_model.dart';
import 'package:elevate/features/home/presentation/screens/product_details_page.dart';
import 'package:http/http.dart' as http;
import '../models/product_card_model.dart';
import '../models/product_details_model.dart';

class ProductService {
  static String baseUrl = "https://elevate-gp.vercel.app/api/v1/";

  // ProductService({required this.baseUrl});

  static Future<List<ProductCardModel>> getAllProductsCards() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final List<dynamic> productsJson = jsonResponse['data'];
      return productsJson.map((json) => ProductCardModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<ProductDetailsModel> getProductDetails(String productId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$productId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return ProductDetailsModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to load product details');
    }
  }
  static Future<ReviewModel> getProductReviews (String productId) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$productId/reviews'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return ReviewModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  // XXSmall
  // XSmall
  // Small
  // Medium
  // Large
  // XLarge
  // XXLarge
  static Future<List<String>?> getAllSizes () async {
    final response = await http.get(Uri.parse('$baseUrl/products/sizes'));

    if (response.statusCode == 200) {
      // final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // final List<String> fullSizes = List<String>.from(
      //     jsonResponse['data']['sizes'] ?? []);
      // List<String> shortSizes = [];
      //   for (var size in fullSizes) {
      //     final regex = RegExp(r'^(X+)?(.*)$', caseSensitive: false);
      //     final match = regex.firstMatch(size);
      //     if (match != null) {
      //       final xPart = match.group(1) ?? '';
      //       final afterX = match.group(2)?.trim() ?? '';
      //       final firstLetter = afterX.isNotEmpty
      //           ? afterX[0].toUpperCase()
      //           : '';
      //       shortSizes.add('$xPart$firstLetter');
      //     } else {
      //       shortSizes.add(size); // fallback
      //     }
      //   }
      //   return shortSizes;
      }
      else {
        throw Exception('Failed to load product details');
      }
  }

    // String? getVariantIdBySize(String shortLabel, ) {
    //   final match = sizeMap.entries.firstWhere(
    //         (entry) => entry.value == shortLabel,
    //     orElse: () => const MapEntry('', ''),
    //   );
    //   return match.key.isEmpty ? null : match.key;
    // }



  }
