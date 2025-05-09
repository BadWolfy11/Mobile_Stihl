import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/user_provider.dart';
import '../../theme/light_color.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = Provider.of<UserProvider>(context).userName ?? 'Пользователь';
    final userLastName = Provider.of<UserProvider>(context).userLastName ?? '-';
    final userEmail = Provider.of<UserProvider>(context).userEmail ?? '-';
    final userPhone = Provider.of<UserProvider>(context).userPhone ?? '-';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Простая иконка вместо изображения профиля
            Container(
              width: double.infinity,
              height: 200,
              alignment: Alignment.center,
              color: Colors.grey[200],
              child: const Icon(Icons.person, size: 100, color: Colors.grey),
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
                    _infoRow('Имя', userName),
                    _infoRow('Фамилия', userLastName),
                    _infoRow('Email', userEmail),
                    _infoRow('Телефон', userPhone),
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
                    Provider.of<UserProvider>(context, listen: false).clearUser();
                    Navigator.pushReplacementNamed(context, '/login');
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