import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  int? _userId;
  String? _token;
  String? _userName;
  String? _userLastName;
  String? _userEmail;
  String? _userPhone;
  int? _roleId;

  final _storage = const FlutterSecureStorage();

  int? get userId => _userId;
  String? get token => _token;
  String? get userName => _userName;
  String? get userLastName => _userLastName;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;
  int? get roleId => _roleId;

  bool get isAdmin => _roleId == 1;
  bool get isStorekeeper => _roleId == 2;
  bool get isSalesman => _roleId == 1001;

  bool get canEditGoods => isAdmin || isStorekeeper;
  bool get canViewUsers => isAdmin;
  bool get canScan => true;

  Future<void> setUserInfo({
    required int userId,
    required String token,
    required String name,
    required String lastName,
    required String email,
    required String phone,
    required int roleId,
  }) async {
    _userId = userId;
    _token = token;
    _userName = name;
    _userLastName = lastName;
    _userEmail = email;
    _userPhone = phone;
    _roleId = roleId;

    await _storage.write(key: 'user_id', value: userId.toString());
    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'user_name', value: name);
    await _storage.write(key: 'user_last_name', value: lastName);
    await _storage.write(key: 'user_email', value: email);
    await _storage.write(key: 'user_phone', value: phone);
    await _storage.write(key: 'user_role_id', value: roleId.toString());

    notifyListeners();
  }

  Future<bool> loadUser() async {
    final savedUserId = await _storage.read(key: 'user_id');
    final savedToken = await _storage.read(key: 'auth_token');
    final savedName = await _storage.read(key: 'user_name');
    final savedLastName = await _storage.read(key: 'user_last_name');
    final savedEmail = await _storage.read(key: 'user_email');
    final savedPhone = await _storage.read(key: 'user_phone');
    final savedRoleId = await _storage.read(key: 'user_role_id');

    if (savedUserId != null && savedToken != null && savedName != null && savedRoleId != null) {
      _userId = int.tryParse(savedUserId);
      _token = savedToken;
      _userName = savedName;
      _userLastName = savedLastName;
      _userEmail = savedEmail;
      _userPhone = savedPhone;
      _roleId = int.tryParse(savedRoleId);
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> clearUser() async {
    _userId = null;
    _token = null;
    _userName = null;
    _userLastName = null;
    _userEmail = null;
    _userPhone = null;
    _roleId = null;
    await _storage.deleteAll();
    notifyListeners();
  }
}
