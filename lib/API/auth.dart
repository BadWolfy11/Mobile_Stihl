

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'API.dart';

class AuthService {
  final API _api = API();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();


  Future<Map<String, dynamic>?> login(String login, String password) async {
    final response = await _api.request(
      RequestMethod.post,
      '/auth/login',
      data: {
        'login': login,
        'password': password,
      },
    );

    if (response.status == 200 && response.body['access_token'] != null) {
      return response.body; 
    }

    return null;
  }


  Future<bool> register(String login, String password, String passwordConfirm, int personId, int roleId) async {
    final response = await _api.request(
      RequestMethod.post,
      '/auth/registration',
      data: {
        'login': login,
        'password': password,
        'password_confirm': passwordConfirm,
        'person_id': personId,
        'role_id': roleId,
      },
    );

    if (response.status == 200 && response.body['access_token'] != null) {
      await _storage.write(key: 'auth_token', value: response.body['access_token']);
      await _storage.write(key: 'user_id', value: response.body['user_id'].toString());
      await _storage.write(key: 'user_role_id', value: response.body['role_id'].toString());
      return true;
    }

    return false;
  }



  Future<void> logout() async {
    await _storage.deleteAll();
  }


  Future<String?> getToken() => _storage.read(key: 'auth_token');
}
