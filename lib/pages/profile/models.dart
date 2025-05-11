final List<Map<String, dynamic>> users = [
  {'id': 1, 'login': 'admin', 'password': '1234', 'role_id': 1, 'person_id': 1},
  {'id': 2, 'login': 'user1', 'password': 'abcd', 'role_id': 2, 'person_id': 2},
];

final List<Map<String, dynamic>> persons = [
  {
    'id': 1,
    'name': 'Иван',
    'last_name': 'Иванов',
    'address_id': 1,
    'email': 'ivan@example.com',
    'phone': '123456789',
    'notes': 'Главный админ',
  },
  {
    'id': 2,
    'name': 'Мария',
    'last_name': 'Петрова',
    'address_id': 2,
    'email': 'maria@example.com',
    'phone': '987654321',
    'notes': 'Обычный пользователь',
  },
];

final List<Map<String, dynamic>> roles = [
  {'id': 1, 'name': 'Администратор'},
  {'id': 2, 'name': 'Пользователь'},
];

final List<Map<String, dynamic>> addresses = [
  {'id': 1, 'street': 'Ленина', 'city': 'Москва', 'zip': '101000'},
  {'id': 2, 'street': 'Мира', 'city': 'СПб', 'zip': '190000'},
];

final List<Map<String, dynamic>> documents = [
  {'id': 1, 'type_id': 1, 'title': 'Паспорт', 'owner_id': 1},
  {'id': 2, 'type_id': 2, 'title': 'ИНН', 'owner_id': 2},
];

final List<Map<String, dynamic>> documentTypes = [
  {'id': 1, 'name': 'Паспорт'},
  {'id': 2, 'name': 'ИНН'},
];
