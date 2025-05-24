import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stihl_mobile/pages/users/data_viewer_page.dart';

import '../config/user_provider.dart';
import '../theme/light_color.dart';
import '../theme/theme.dart';
import 'goods_history/history_page.dart';
import 'scanner/scan_Page.dart';
import 'profile/profile_page.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _greeting(String name) {
    final today = DateFormat('d MMMM yyyy', 'ru_RU').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 22, color: Colors.white),
              children: [
                const TextSpan(
                  text: 'Добро пожаловать, ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' $name!',
                  style: const TextStyle(color: LightColor.orange, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Сегодня: $today',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }


  Widget _avatarInAppBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserProfileScreen()));
      },
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
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context).userId;
    final user = Provider.of<UserProvider>(context);

    if (userId == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const SizedBox.shrink();
    }

    final userName = Provider.of<UserProvider>(context).userName ?? 'Пользователь';

    return Scaffold(
      backgroundColor: LightColor.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/main_background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Главная',
                              style: TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            _avatarInAppBar(context),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _greeting(userName),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _actionButton(
              context,
              'Открыть камеру',
              Icons.qr_code_scanner,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ScanScreen()),
                );
              },
            ),
            if (user.canViewUsers)
              _actionButton(
                context,
                'Данные',
                Icons.people,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DataViewerPage()),
                  );
                },
              ),

            if (user.canEditGoods)
              _actionButton(
                context,
                'История',
                Icons.history,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => GoodsHistoryPage()),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}