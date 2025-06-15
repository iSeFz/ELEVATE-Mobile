import 'dart:convert';
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

// You can add more product-related methods here, e.g.
// Future<Product> getProductById(int id) { ... }
// Future<void> createProduct(Product product) { ... }
}
