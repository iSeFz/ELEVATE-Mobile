import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/constants.dart';
import '../../../product_details/data/models/product_card_model.dart';

class WishlistService {
  Future<List<ProductCardModel>> fetchWishlist(String userID) async {
    try {
      final response = await http.get(
        Uri.parse("$apiBaseURL/v1/customers/me/wishlist?userId=$userID"),
        headers: {testAuthHeader: testAuthValue},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        final List<dynamic> productsJson = responseData['data'];
        return productsJson
            .map((json) => ProductCardModel.fromJson(json))
            .toList();
      } else {
        throw Exception(responseData['message'] ?? 'Failed to load wishlist');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> removeFromWishlist(String userID, String productID) async {
    try {
      final response = await http.delete(
        Uri.parse(
          "$apiBaseURL/v1/customers/me/wishlist/items/$productID?userId=$userID",
        ),
        headers: {testAuthHeader: testAuthValue},
      );

      // Return true if the removal was done successfully
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
