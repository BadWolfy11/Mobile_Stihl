import 'API.dart';

class ExpenseCategoriesService {
  final API _api;

  ExpenseCategoriesService({required String token}) : _api = API(token: token);

  Future<List<Map<String, dynamic>>> getExpenseCategories() async {
    final response = await _api.request(RequestMethod.get, '/expense_categories/all');
    if (response.status == 200 && response.body is List) {
      return List<Map<String, dynamic>>.from(response.body);
    }
    return [];
  }

}
