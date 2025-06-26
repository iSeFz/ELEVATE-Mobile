import 'dart:convert';
import 'package:elevate/features/product_details/data/models/review_model.dart';
import 'package:elevate/features/product_details/presentation/screens/product_details_page.dart';
import 'package:http/http.dart' as http;
import '../models/product_card_model.dart';
import '../models/product_details_model.dart';
import '../../../../core/constants/constants.dart';

class ProductService {
  // Retrieve a single page of products
  Future<List<ProductCardModel>> getProductPage(int pageNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$apiBaseURL/v1/products?page=$pageNumber'),
      );

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = jsonResponse['data'];
        return productsJson
            .map((json) => ProductCardModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  static Future<ProductDetailsModel> getProductDetails(String productId) async {
    final response = await http.get(
      Uri.parse('$apiBaseURL/v1/products/$productId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return ProductDetailsModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  static Future<List<ProductCardModel>> getRelatedProducts(
      String productId,) async {
    final body = {
      "requests": [
        {
          "indexName": "product",
          "model": "related-products",
          "objectID": productId,
          "threshold": 0,
          "maxRecommendations": 5,
          "queryParameters": {
            "attributesToRetrieve": [
              "objectID",
              "brandName",
              "name",
              "variants",
            ],
          },
        },
      ],
    };

    try {
      final response = await http.post(
        Uri.parse(algoliaBaseURL),
        headers: {
          algoliaAppIDHeader: algoliaAppIDValue,
          algoliaAPIKeyHeader: algoliaAPIKeyValue,
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

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


  //________________FILTERING____________________

  static Future<Map<String, List<String>>> getAllCategories() async {
    final response = await http.get(
        Uri.parse('$apiBaseURL/v1/products/categories'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> categories = jsonResponse['data'];

      final Map<String, List<String>> mappedCategories = {};

      for (final item in categories) {
        if (item.contains(' - ')) {
          final parts = item.split(' - ');
          final key = parts[0].trim();
          final value = parts[1].trim();

          if (!mappedCategories.containsKey(key)) {
            mappedCategories[key] = [];
          }
          mappedCategories[key]!.add(value);
        } else {
          // categories without ' - '
          mappedCategories.putIfAbsent(item, () => []);
        }
      }

      return mappedCategories;
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<String>> getAllDepartments() async {
    final response = await http.get(
        Uri.parse('$apiBaseURL/v1/products/departments'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> rawList = jsonResponse['data'];

      // Cast each item to String
      final List<String> departments = rawList.map((item) => item.toString()).toList();

      return departments;
    } else {
      throw Exception('Failed to load departments');
    }
  }

}





