import './API.dart';

class RoleService {
  final API _api;

  RoleService({required String token}) : _api = API(token: token);



  Future<Map<String, dynamic>?> getRoleById(int id) async {
    final response = await _api.request(
      RequestMethod.get,
      '/role/get/$id',
    );

    if (response.status == 200 && response.body is Map<String, dynamic>) {
      return response.body;
    }

    return null;
  }

  Future<bool> createRole(Map<String, dynamic> data) async {
    final response = await _api.request(
      RequestMethod.post,
      '/role/create',
      data: data,
    );

    return response.status == 200 || response.status == 201;
  }

  Future<bool> updateRole(int id, Map<String, dynamic> data) async {
    final response = await _api.request(
      RequestMethod.patch,
      '/role/update/$id',
      data: data,
    );

    return response.status == 200;
  }

  Future<bool> deleteRole(int id) async {
    final response = await _api.request(
      RequestMethod.delete,
      '/role/delete/$id',
    );

    return response.status == 200;
  }

  Future<List<Map<String, dynamic>>> getAllRoles() async {
    final response = await _api.request(RequestMethod.get, '/role/all');
    if (response.status == 200 && response.body is List) {
      return List<Map<String, dynamic>>.from(response.body);
    }
    return [];
  }
}
