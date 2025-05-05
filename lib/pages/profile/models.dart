// Мок-данные для пользователей
final List<Map<String, dynamic>> users = List.generate(
  10, // Например, 10 пользователей
      (index) => {
    'id': index + 1,
    'login': 'user${index + 1}',
    'password': 'password${index + 1}',
    'role_id': (index % 3) + 1, // Пример, создаем 3 роли
    'person_id': index + 1, // Связь с таблицей person
  },
);

// Мок-данные для персон
final List<Map<String, dynamic>> persons = List.generate(
  10, // 10 персон
      (index) => {
    'id': index + 1,
    'name': 'Имя ${index + 1}',
    'last_name': 'Фамилия ${index + 1}',
    'address_id': index + 1, // Пример связи с таблицей address
    'email': 'user${index + 1}@example.com',
    'phone': '8${(index + 1).toString().padLeft(9, '0')}', // Например, телефон в формате "8XXXXXXXXX"
    'notes': 'Примечание для пользователя ${index + 1}',
  },
);

// Мок-данные для адресов
final List<Map<String, dynamic>> addresses = List.generate(
  10, // 10 адресов
      (index) => {
    'id': index + 1,
    'city': 'Город ${index + 1}',
    'street': 'Улица ${index + 1}',
    'appartment': 'Квартира ${index + 1}',
  },
);

// Мок-данные для документов (например, паспорта)
final List<Map<String, dynamic>> documents = List.generate(
  10, // 10 документов (паспортов)
      (index) => {
    'id': index + 1,
    'type_id': 1, // Тип документа (например, паспорт)
    'name': 'Паспорт ${index + 1}', // Название документа
    'data': '2025-05-01', // Дата документа
    'person_id': index + 1, // Связь с личной информацией
  },
);

// Мок-данные для типов документов (например, паспорт)
final List<Map<String, dynamic>> documentTypes = [
  {
    'id': 1,
    'name': 'Паспорт',
  },
  {
    'id': 2,
    'name': 'Свидетельство о рождении',
  },
  // Другие типы документов можно добавить по необходимости
];
