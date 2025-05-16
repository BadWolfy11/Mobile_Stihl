import 'package:stihl_mobile/API/API.dart';

import 'address.dart';
import 'persons.dart';
import 'users.dart';

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

  if (userId == null) {
    final addressId = await addressService.createAddress(addressData);
    final personId = await personService.createPerson({...personData, 'address_id': addressId});

    try {
      final user = await userService.createUser(
          {...userData, 'person_id': personId}
      );
    } on APIResponse catch (e) {
      if (e.status == 422 && e.body['detail'].contains('is already registered')) {
        // delete address by id
        // delete person by id
        // return error message - user with current username already registered
      }
      // return "unknown error"
    } catch (e) {
      // return "unknown error"
    }
  } else {
    final updates = <Future>[];

    if (originalUser != null && userData['login'].toString() != originalUser['login'].toString()) {
      final candidate = await userService.searchUsers(
        login: userData['login'].toString()
      );

      if (candidate['totalCount'] > 0) {
        print('user alredy exists');

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
