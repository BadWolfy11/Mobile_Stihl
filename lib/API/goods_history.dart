import '../API/API.dart';

class GoodsHistoryService {
  final API _api;
  GoodsHistoryService({required String token}) : _api = API(token: token);

  Future<Map<String, dynamic>> searchGoodsHistory({int offset = 0, int limit = 20}) async {
    final response = await _api.request(
      RequestMethod.get,
      '/goods_history/search',
      params: {
        'offset': offset.toString(),
        'limit': limit.toString(),
      },
    );
    return response.status == 200 && response.body is Map
        ? Map<String, dynamic>.from(response.body)
        : {'totalCount': 0, 'items': []};
  }
}
