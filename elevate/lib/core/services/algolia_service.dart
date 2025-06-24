import 'package:algolia/algolia.dart';

class AlgoliaService {
  static const Algolia _algolia = Algolia.init(
    applicationId: 'CDE7ONXAU6',
    apiKey: 'acd7ae1f95e5edee258b99bd5a8d259b',
  );

  static Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final safeQuery = query.isEmpty ? '' : query;
    final results = await _algolia.index('product').query(safeQuery).getObjects();
    print('Algolia search results: ${results.hits.length} hits for query "$query"');
    return results.hits.map((hit) => hit.data).toList();
  }
}
