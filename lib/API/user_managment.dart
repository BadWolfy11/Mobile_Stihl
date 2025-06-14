import 'address.dart';
import 'persons.dart';
import 'users.dart';
import 'auth.dart';

Future<void> saveUser({
  required String token,
  int? userId,
  required Map<String, dynamic> addressData,
  required Map<String, dynamic> personData,
  required Map<String, dynamic> userData,
  Map<String, dynamic>? originalUser,
  Map<String, dynamic>? originalPerson,
  Map<String, dynamic>? originalAddress,
}) async {
  final addressService = AddressService(token: token);
  final personService = PersonService(token: token);
  final userService = UserService(token: token);
  final authService = AuthService();

  if (userId == null) {
    final addressId = await addressService.createAddress(addressData);
    final personId = await personService.createPerson({
      ...personData,
      'address_id': addressId,
    });

    final login = userData['login'];
    final password = userData['password'];
    final roleId = userData['role_id'];

    if (login == null || password == null || roleId == null) {
      throw Exception("Не хватает данных, Вы ввели не все данные для регистрации");
    }
    final response = await authService.register(
      login,
      password,
      password,
      personId!,
      roleId,
    );

    if (!response) {
      throw Exception("Ошибка регистрации");
    }
  } else {
    final updates = <Future>[];

    if (originalUser != null && userData['login'].toString() != originalUser['login'].toString()) {
      final candidate = await userService.searchUsers(
        login: userData['login'].toString(),
      );

      if (candidate['totalCount'] > 0) {
        print('Пользователь с таким ником уже существует');
        return;
      }
    }

    if (personData.toString() != originalPerson.toString()) {
      updates.add(personService.updatePerson(originalPerson?['id'], personData));
    }
    if (addressData.toString() != originalAddress.toString()) {
      updates.add(addressService.updateAddress(originalAddress?['id'], addressData));
    }
    if (userData.toString() != originalUser.toString()) {
      updates.add(userService.updateUser(userId, userData));
    }

    await Future.wait(updates);
  }



}

Future<bool> deleteUserWithRelations({
  required String token,
  required int userId,
  required int? personId,
  required int? addressId,
}) async {
  final userService = UserService(token: token);
  final personService = PersonService(token: token);
  final addressService = AddressService(token: token);

  try {
    await userService.deleteUser(userId);
    if (personId != null) await personService.deletePerson(personId);
    if (addressId != null) await addressService.deleteAddress(addressId);
    return true;
  } catch (e) {
    print('Ошибка при удалении: $e');
    return false;
  }
}