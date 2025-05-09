import 'API.dart';

class CategoriesService extends API {
  CategoriesService({required super.token});

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await request(
      RequestMethod.get,
      '/categories/all',
    );

    if (response.status == 200 && response.body is List) {
      return List<Map<String, dynamic>>.from(response.body);
    } else {
      return [];
    }
  }
}
