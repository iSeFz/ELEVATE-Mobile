import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/constants.dart';
import '../models/brand_model.dart';

class BrandService {
  static Future<List<String>> getAllBrandNames() async {
    final response = await http.get(Uri.parse('$apiBaseURL/v1/brands'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> brands = jsonResponse['data'];

      // Convert to BrandModel list
      final List<BrandModel> brandModels = brands
          .map((brand) => BrandModel.fromJson(brand))
          .toList();

      // Extract brand names
      return brandModels.map((brand) => brand.name).toList();
    } else {
      throw Exception('Failed to load brands');
    }
  }

}