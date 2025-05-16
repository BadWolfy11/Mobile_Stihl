import 'package:flutter/material.dart';
import 'data_dialog.dart'; // путь к форме редактирования пользователя

class UserDetailPage extends StatelessWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> person;
  final Map<String, dynamic> role;
  final Map<String, dynamic> address;

  const UserDetailPage({
    super.key,
    required this.user,
    required this.person,
    required this.role,
    required this.address,
  });

  Widget buildSection(String title, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.orange)),
            const SizedBox(height: 12),
            ...data.entries.map(
                  (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        entry.key,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        _formatValue(entry.value),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return '-';
    if (value is Map) {
      return value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    }
    if (value is List) {
      return value.join(', ');
    }
    return value.toString();
  }


  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Удалить пользователя"),
        content: const Text("Вы уверены, что хотите удалить этого пользователя?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Отмена"),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete, color: Colors.white),
            label: const Text("Удалить", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Пользователь удалён (демо)")),
              );
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Пользователь ID ${user['id']} - ${user['login']}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          buildSection('Персона', person),
          buildSection('Роль', role),
          buildSection('Адрес', address),
        ],
      ),
      bottomSheet: Container(

        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => UserEditDialog(
                      userId: user['id'],
                      user: user,
                      person: person,
                      address: address,
                      role: role,

                    ),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text("Редактировать", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),

            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _showDeleteConfirmation(context),
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text(""),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
