import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../API/role.dart';
import '../../API/user_managment.dart';
import '../../config/user_provider.dart';

class UserEditDialog extends StatefulWidget {
  final int? userId;
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? person;
  final Map<String, dynamic>? role;
  final Map<String, dynamic>? address;

  const UserEditDialog({
    Key? key,
    this.userId,
    this.user,
    this.person,
    this.role,
    this.address,
  }) : super(key: key);

  @override
  _UserEditDialogState createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<UserEditDialog> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _appartmentController = TextEditingController();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  List<Map<String, dynamic>> _roles = [];
  int? _selectedRoleId;

  Map<String, dynamic> _originalUser = {};
  Map<String, dynamic> _originalPerson = {};
  Map<String, dynamic> _originalAddress = {};

  bool _isLoading = true;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _loadRoles();

    if (widget.userId != null && widget.user != null) {
      _originalUser = widget.user!;
      _originalPerson = widget.person ?? {};
      _originalAddress = widget.address ?? {};

      _nameController.text = _originalPerson['name'] ?? '';
      _lastNameController.text = _originalPerson['last_name'] ?? '';
      _emailController.text = _originalPerson['email'] ?? '';
      _phoneController.text = _originalPerson['phone'] ?? '';
      _cityController.text = _originalAddress['city'] ?? '';
      _streetController.text = _originalAddress['street'] ?? '';
      _appartmentController.text = _originalAddress['appartment'] ?? '';
      _loginController.text = _originalUser['login'] ?? '';
      _selectedRoleId = _originalUser['role_id'];

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRoles() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;
    final roleService = RoleService(token: token);
    final roles = await roleService.getAllRoles();
    setState(() {
      _roles = List<Map<String, dynamic>>.from(roles);
    });
  }

  void _nextTab() => setState(() => _currentTab = (_currentTab + 1) % 4);
  void _prevTab() => setState(() => _currentTab = (_currentTab - 1 + 4) % 4);

  Future<void> _save() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    print('userData: ${{
      'login': _loginController.text,
      'password': _passwordController.text,
      'role_id': _selectedRoleId,
    }}');
    print('personData: ${{
      'name': _nameController.text,
      'last_name': _lastNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    }}');
    print('addressData: ${{
      'city': _cityController.text,
      'street': _streetController.text,
      'appartment': _appartmentController.text,
    }}');

    await saveUser(
      token: token,
      userId: widget.userId,
      addressData: {
        'city': _cityController.text,
        'street': _streetController.text,
        'appartment': _appartmentController.text,
      },
      personData: {
        'name': _nameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      },
      userData: {
        'login': _loginController.text,
        if (_passwordController.text.isNotEmpty) 'password': _passwordController.text,
        'role_id': _selectedRoleId,
      },
      originalUser: widget.user,
      originalPerson: widget.person,
      originalAddress: widget.address,
    );

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return AlertDialog(
      title: Text(widget.userId == null ? 'Создание пользователя' : 'Редактирование пользователя'),
      content: SizedBox(
        width: 400,
        height: 420,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(onPressed: _prevTab, icon: const Icon(Icons.arrow_back)),
                Expanded(
                  child: Center(
                    child: Text(
                      ['Роль', 'Адрес', 'Персона', 'Учётка'][_currentTab],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
                IconButton(onPressed: _nextTab, icon: const Icon(Icons.arrow_forward)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  _buildRoleTab(),
                  _buildAddressTab(),
                  _buildPersonTab(),
                  _buildUserTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildRoleTab() {
    return ListView(
      children: _roles.map((role) {
        return RadioListTile<int>(
          value: role['id'],
          groupValue: _selectedRoleId,
          title: Text(
            role['name']?.toString() ?? 'Без названия',
            style: const TextStyle(color: Colors.orange),
          ),
          onChanged: (value) => setState(() => _selectedRoleId = value),
        );
      }).toList(),
    );
  }


  Widget _buildAddressTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _orangeTextField(_cityController, 'Город'),
          _orangeTextField(_streetController, 'Улица'),
          _orangeTextField(_appartmentController, 'Квартира'),
        ],
      ),
    );
  }


  Widget _buildPersonTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _orangeTextField(_nameController, 'Имя'),
          _orangeTextField(_lastNameController, 'Фамилия'),
          _orangeTextField(_emailController, 'Email'),
          _orangeTextField(_phoneController, 'Телефон'),
        ],
      ),
    );
  }


  Widget _buildUserTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _orangeTextField(_loginController, 'Логин'),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Пароль',
              labelStyle: TextStyle(color: Colors.orange),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }


  Widget _orangeTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.orange),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          border: const OutlineInputBorder(),
        ),
      ),

    );
  }
}