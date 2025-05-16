import '../API/API.dart';
import 'persons.dart';
import 'address.dart';

class UserService {
  final API _api;

  UserService({required String token}) : _api = API(token: token);

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final response = await _api.request(RequestMethod.get, '/users/get/$id');
    return response.status == 200 ? response.body : null;
  }

  Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    final response = await _api.request(RequestMethod.patch, '/users/update/$id', data: data);
    return response.status == 200;
  }

  Future<Map<String, dynamic>> searchUsers({
    int? id,
    String? login,
    int? personId,
    int? roleId,
    int offset = 0,
    int limit = 20,
  }) async {
    final params = <String, String>{
      'offset': offset.toString(),
      'limit': limit.toString(),
    };

    if (id != null) params['id'] = id.toString();
    if (login != null && login.isNotEmpty) params['login'] = login;
    if (personId != null) params['person_id'] = personId.toString();
    if (roleId != null) params['role_id'] = roleId.toString();

    final response = await _api.request(
      RequestMethod.get,
      '/users/search',
      params: params,
    );

    if (response.status == 200 && response.body is Map) {
      return Map<String, dynamic>.from(response.body);
    }

    return {'totalCount': 0, 'items': []};
  }

  Future<int> createUser(Map<String, dynamic> data) async {
    final response = await _api.request(RequestMethod.post, '/users/create', data: data);

    if (response.status == 200 || response.status == 201) {
      return response.body['id'];
    }

    print('Ошибка создания пользователя: ${response.status}');

    throw response;
  }

}



