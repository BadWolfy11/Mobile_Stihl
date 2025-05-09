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
}

