import '../API/API.dart';



class PersonService {
  final API _api;

  PersonService({required String token}) : _api = API(token: token);

  Future<Map<String, dynamic>?> getPersonById(int personId) async {
    try {
      final response = await _api.request(
        RequestMethod.get,
        '/person/get/$personId',
      );

      if (response.status == 200) {
        return response.body;
      } else {
        print('Ошибка получения персоны: ${response.status} ${personId}');
        return null;
      }
    } catch (e) {
      print('Ошибка запроса к /person/get/$personId: $e');
      return null;
    }
  }

  Future<bool> updatePerson(int id, Map<String, dynamic> data) async {
    final response = await _api.request(
      RequestMethod.patch,
      '/person/update/$id',
      data: data,
    );
    return response.status == 200;
  }

  Future<Map<String, dynamic>> searchPersons({
    int? id,
    String? name,
    String? lastName,
    String? email,
    String? phone,
    int offset = 0,
    int limit = 20,
  }) async {
    final params = <String, String>{
      'offset': offset.toString(),
      'limit': limit.toString(),
    };

    if (id != null) params['id'] = id.toString();
    if (name != null && name.isNotEmpty) params['name'] = name;
    if (lastName != null && lastName.isNotEmpty) params['last_name'] = lastName;
    if (email != null && email.isNotEmpty) params['email'] = email;
    if (phone != null && phone.isNotEmpty) params['phone'] = phone;

    final response = await _api.request(
      RequestMethod.get,
      '/person/search',
      params: params,
    );

    if (response.status == 200 && response.body is Map) {
      return Map<String, dynamic>.from(response.body);
    }

    return {'totalCount': 0, 'items': []};
  }

  Future<int?> createPerson(Map<String, dynamic> data) async {
    final response = await _api.request(RequestMethod.post, '/person/create', data: data);
    if (response.status == 200 || response.status == 201) {
      return response.body['id'];
    }
    return null;
  }

}

