import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_card_model.dart';
import '../models/product_details_model.dart';

class ProductService {
  static String baseUrl = "https://elevate-gp.vercel.app/api/v1/";

  static Future<List<ProductCardModel>> getAllProductsCards() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final List<dynamic> productsJson = jsonResponse['data'];
      return productsJson
          .map((json) => ProductCardModel.fromJson(json))
          .toList();
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

  static Future<List<ProductCardModel>> getRelatedProducts(
    String productId,
  ) async {
    final url = 'https://AEZ0KDU74P.algolia.net/1/indexes/*/recommendations';

    final headers = {
      'X-Algolia-Application-Id': 'AEZ0KDU74P',
      'X-Algolia-API-Key': 'ad4de708ee025e45a75f2019d8a44280',
      'Content-Type': 'application/json',
    };

    final body = {
      "requests": [
        {
          "indexName": "product",
          "model": "related-products",
          "objectID": productId,
          "threshold": 0,
          "maxRecommendations": 5,
          "queryParameters": {
            "attributesToRetrieve": ["objectID", "brandName", "name", "variants"]
          }
        },
      ],
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('results') &&
            jsonResponse['results'].isNotEmpty &&
            jsonResponse['results'][0].containsKey('hits')) {
          final List<dynamic> hits = jsonResponse['results'][0]['hits'];

          return hits.map<ProductCardModel>((json) {
            // Extract the first variant for image and price
            final variants = json['variants'] as List;
            final firstVariant = variants.isNotEmpty ? variants[0] : null;
            final images =
                firstVariant != null && firstVariant['images'] != null
                    ? firstVariant['images'] as List
                    : [];

            return ProductCardModel(
              id: json['objectID'],
              brandName: json['brandName'],
              name: json['name'],
              price: firstVariant != null ? firstVariant['price'] : 0,
              image: images.isNotEmpty ? images[0] : '',
            );
          }).toList();
        }
        return [];
      } else {
        throw Exception(
          'Failed to load related products: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load related products: $e');
    }
  }
}
