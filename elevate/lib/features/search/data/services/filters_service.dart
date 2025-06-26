import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/constants.dart';

class FilterService {
  static Future<Map<String, List<String>>> getAllProductsCategories() async {
    final response = await http.get(
      Uri.parse('$apiBaseURL/v1/products/categories'),
    );

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
}
