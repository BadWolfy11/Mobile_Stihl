import 'package:flutter/material.dart';
import 'package:stihl_mobile/pages/scanner/scan_Page.dart';
import '../theme/light_color.dart';
import '../theme/theme.dart';
import 'package:intl/intl.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({Key? key}) : super(key: key);

  Widget _greeting() {
    final today = DateFormat('d MMMM yyyy', 'ru_RU').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 22, color: Colors.black),
              children: [
                TextSpan(
                  text: 'Добро ',
                  style: TextStyle(color: LightColor.orange),
                ),
                TextSpan(text: 'пожаловать, Пользователь!'),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Сегодня: $today',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
  // Квадратная аватарка в AppBar
  Widget _avatarInAppBar(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'profile') {
          // TODO: Навигация на профиль
          Navigator.pushNamed(context, '/profile');
        } else if (value == 'logout') {
          // TODO: Выйти из аккаунта
          // Например: context.read<AuthService>().logout();
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.black),
              SizedBox(width: 8),
              Text('Профиль'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.black),
              SizedBox(width: 8),
              Text('Выйти'),
            ],
          ),
        ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.person, color: Colors.orange, size: 24),
      ),
    );
  }

  // Белая кнопка с светло-серой рамкой и черным текстом
  Widget _actionButton(
      BuildContext context,
      String label,
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: AppTheme.shadow,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: LightColor.background,
      appBar: AppBar(
        backgroundColor: LightColor.background,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Главная',
              style: TextStyle(
                fontSize: 24,
                color: LightColor.black,
              ),
            ),
            _avatarInAppBar(context),
          ],
        ),
        automaticallyImplyLeading: false, // Удаляет стрелку "назад"
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _greeting(),
            _actionButton(
              context,
              'Открыть камеру',
              Icons.qr_code_scanner,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanScreen()),
                );
              },
            ),
            _actionButton(
              context,
              'Пользователи',
              Icons.people,
                  () {
                // TODO: Навигация на страницу пользователей
              },
            ),
            _actionButton(
              context,
              'История',
              Icons.history,
                  () {
                // TODO: Навигация на страницу истории
              },
            ),
          ],
        ),
      ),
    );
  }
}
