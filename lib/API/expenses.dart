import '../API/API.dart';

class ExpensesService {
  final API _api;

  ExpensesService({required String token}) : _api = API(token: token);

  Future<Map<String, dynamic>> searchExpenses({
    String? name,
    int? categoryId,
    required int limit,
    required int offset,
  }) async {
    final params = {
      'limit': limit.toString(),
      'offset': offset.toString(),
    };

    if (name != null && name.isNotEmpty) {
      params['name'] = name;
    }

    if (categoryId != null) {
      params['expense_category_id'] = categoryId.toString();
    }


    print('[searchExpenses] Параметры запроса: $params');

    try {
      final response = await _api.request(RequestMethod.get, '/expenses/search', params: params);


      print('[searchExpenses] Статус: ${response.status}');
      print('[searchExpenses] Ответ: ${response.body}');

      if (response.status == 200 && response.body is Map<String, dynamic>) {
        return Map<String, dynamic>.from(response.body);
      }


      print('[searchExpenses] Неожиданный ответ: ${response.status}');
    } catch (e, stacktrace) {

      print('[searchExpenses] Ошибка при запросе: $e');
      print(stacktrace);
    }

    return {'items': [], 'totalCount': 0};
  }


  Future<bool> deleteExpense(int id) async {
    final response = await _api.request(
      RequestMethod.delete,
      '/expenses/delete/$id',
    );
    return response.status == 200;
  }


  Future<bool> createExpense(Map<String, dynamic> data) async {
    final response = await _api.request(
      RequestMethod.post,
      '/expenses/create',
      data: data,
    );
    return response.status == 201 || response.status == 200;
  }

  Future<bool> updateExpense(int id, Map<String, dynamic> data) async {
    final response = await _api.request(
      RequestMethod.patch,
      '/expenses/update/$id',
      data: data,
    );
    return response.status == 200;
  }

}
