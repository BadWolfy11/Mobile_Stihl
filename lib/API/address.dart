import '../API/API.dart';

class AddressService {
  final API _api;

  AddressService({required String token}) : _api = API(token: token);

  Future<Map<String, dynamic>?> getAddressById(int id) async {
    final response = await _api.request(RequestMethod.get, '/address/get/$id');
    return response.status == 200 ? response.body : null;
  }

  Future<bool> updateAddress(int id, Map<String, dynamic> data) async {
    final response = await _api.request(RequestMethod.patch, '/address/update/$id', data: data);
    return response.status == 200;
  }

  Future<int?> createAddress(Map<String, dynamic> data) async {
    final response = await _api.request(RequestMethod.post, '/address/create', data: data);
    if (response.status == 200 || response.status == 201) {
      return response.body['id'];
    }
    print('Ошибка создания адреса: ${response.status}');
    return null;
  }

  Future<bool> deleteAddress(int id) async => await _api.request(
    RequestMethod.delete, '/address/delete/$id',
  ).then((res) => res.status == 200);
}
