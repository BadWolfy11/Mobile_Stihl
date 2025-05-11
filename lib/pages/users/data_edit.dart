import 'package:flutter/material.dart';

class UserEditDialog extends StatelessWidget {
  final bool isEditMode;

  const UserEditDialog({super.key, this.isEditMode = false});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: AlertDialog(
        title: Text(isEditMode ? 'Редактировать пользователя' : 'Создать пользователя'),
        content: SizedBox(
          width: 400,
          height: 400,
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.orange,
                tabs: const [
                  Tab(text: 'Роль'),
                  Tab(text: 'Город'),
                  Tab(text: 'Персона'),
                  Tab(text: 'Логин/Пароль'),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildRoleTab(),
                    _buildCityTab(),
                    _buildPersonTab(),
                    _buildCredentialsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              // TODO: сохранить
            },
            child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleTab() {
    return Center(child: Text('Редактирование роли'));
  }

  Widget _buildCityTab() {
    return Center(child: Text('Редактирование города'));
  }

  Widget _buildPersonTab() {
    return Center(child: Text('Редактирование данных персоны'));
  }

  Widget _buildCredentialsTab() {
    return Center(child: Text('Редактирование логина и пароля'));
  }
}
