import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/user_provider.dart';
import '../../theme/light_color.dart';
import 'models.dart';


class UserProfileScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final person = persons.firstWhere((p) => p['id'] == user['person_id']);
    final address = addresses.firstWhere((a) => a['id'] == person['address_id']);
    final document = documents.firstWhere((d) => d['person_id'] == person['id']);
    final docType = documentTypes.firstWhere((t) => t['id'] == document['type_id']);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя квадратная аватарка (с заглушкой)
            Container(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                'assets/images/profile.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.person, size: 100, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Заголовок
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ПЕРСОНАЛЬНАЯ ИНФОРМАЦИЯ',
                  style: TextStyle(
                    color: LightColor.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Информационная карточка
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow('ФИО', '${person['name']} ${person['last_name']}'),
                    _infoRow('Email', person['email']),
                    _infoRow('Телефон', person['phone']),
                    _infoRow('Город', address['city']),
                    _infoRow('Улица', address['street']),
                    _infoRow('Квартира', address['appartment']),
                    _infoRow('Паспорт', document['name']),
                    _infoRow('Тип документа', docType['name']),
                    _infoRow('Дата выдачи', document['data']),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Кнопка выхода
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Логика выхода
                    Provider.of<UserProvider>(context, listen: false).clearUser(); // очищаем userId
                    Navigator.pushReplacementNamed(context, '/login'); // переход на логин
                  },
                  icon: const Icon(Icons.exit_to_app, color: Colors.white),
                  label: const Text(
                    'Выйти из системы',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LightColor.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
