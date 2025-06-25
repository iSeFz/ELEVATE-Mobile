import 'package:algolia/algolia.dart';

class AlgoliaService {
  static const Algolia _algolia = Algolia.init(
    applicationId: 'AEZ0KDU74P',
    apiKey: 'ad4de708ee025e45a75f2019d8a44280',
  );

  static Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final safeQuery = query.isEmpty ? '' : query;
    final results = await _algolia.index('product').query(safeQuery).getObjects();
    // print('Algolia search results: ${results.hits.length} hits for query "$query"');
    return results.hits.map((hit) => hit.data).toList();
  }

}
