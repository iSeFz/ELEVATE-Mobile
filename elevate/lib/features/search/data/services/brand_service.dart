import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/constants.dart';
import '../models/brand_model.dart';

class BrandService {
  static Future<List<String>> getAllBrandNames({int perPage = 20}) async {
    int currentPage = 1;
    int totalPages = 1;
    List<String> allBrandNames = [];

    try {
      while (currentPage <= totalPages) {
        final response = await http.get(Uri.parse(
            '$apiBaseURL/v1/brands?page=$currentPage&perPage=$perPage'));

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);

          final List<dynamic> brands = jsonResponse['data'];
          final List<BrandModel> brandModels = brands
              .map((brand) => BrandModel.fromJson(brand))
              .toList();

          allBrandNames.addAll(brandModels
              .map((brand) => brand.name ?? '')
              .where((name) => name.isNotEmpty));

          // Read pagination info
          final meta = jsonResponse['meta'];
          totalPages = meta['totalPages'];
          currentPage++;
        } else {
          throw Exception('Failed to load brands on page $currentPage');
        }
      }
    } catch (e) {
      print('Error fetching brands: $e');
      return [];
    }

    print('Fetched all brand names: $allBrandNames');
    return allBrandNames;
  }
}
