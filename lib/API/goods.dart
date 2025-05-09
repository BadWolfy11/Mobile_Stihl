import '../API/API.dart';

class GoodsService {
  final API _api;

  GoodsService({required String token}) : _api = API(token: token);

  Future<List<Map<String, dynamic>>> searchGoods({
    int? id,
    String? name,
    String? barcode,
    int? categoryId,
  }) async {
    final params = <String, String>{};

    if (id != null) params['id'] = id.toString();
    if (name != null && name.isNotEmpty) params['name'] = name;
    if (barcode != null && barcode.isNotEmpty) params['barcode'] = barcode;
    if (categoryId != null) params['category_id'] = categoryId.toString();

    final response = await _api.request(
      RequestMethod.get,
      '/goods/search',
      params: params,
    );

    if (response.status == 200 && response.body is List) {
      return List<Map<String, dynamic>>.from(response.body);
    }

    return [];
  }

  Future<Map<String, dynamic>?> getGoodsById(int id) async {
    final response = await _api.request(
      RequestMethod.get,
      '/goods/get/$id',
    );

    if (response.status == 200 && response.body is Map<String, dynamic>) {
      return response.body;
    }

    return null;
  }

  Future<bool> createGoods(Map<String, dynamic> data) async {
    final response = await _api.request(RequestMethod.post, '/goods/create', data: data);
    return response.status == 200 || response.status == 201;
  }

  Future<bool> updateGoods(int id, Map<String, dynamic> data) async {
    print(data);
    final response = await _api.request(RequestMethod.patch, '/goods/update/$id', data: data);

    return response.status == 200;
  }

  Future<bool> deleteGoods(int id) async {
    final response = await _api.request(
      RequestMethod.delete,
      '/goods/delete/$id',
    );
    return response.status == 200;
  }

}
