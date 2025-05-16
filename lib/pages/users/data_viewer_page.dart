import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../API/users.dart';
import '../../API/persons.dart';
import '../../API/address.dart';
import '../../API/role.dart';
import '../../config/user_provider.dart';
import '../../widgets/search_filter.dart';
import '../../widgets/pagination_bar.dart';
import 'data_card.dart';
import 'data_detail_page.dart';
import 'data_dialog.dart';

class DataViewerPage extends StatefulWidget {
  @override
  _DataViewerPageState createState() => _DataViewerPageState();
}

class _DataViewerPageState extends State<DataViewerPage> {
  String searchQuery = '';
  int currentPage = 1;
  final int itemsPerPage = 10;

  List<Map<String, dynamic>> _users = [];
  int _totalCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    setState(() => _isLoading = true);

    final userService = UserService(token: token);
    final personService = PersonService(token: token);
    final offset = (currentPage - 1) * itemsPerPage;
    final data = await userService.searchUsers(
      login: searchQuery,
      offset: offset,
      limit: itemsPerPage,
    );

    final users = List<Map<String, dynamic>>.from(data['items']);
    _totalCount = data['totalCount'] ?? 0;

    // Получение данных персоны для каждого пользователя
    for (var user in users) {
      final personId = user['person_id'];
      if (personId != null) {
        final person = await personService.getPersonById(personId);
        user['person'] = person;
      }
    }

    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  int get totalPages => (_totalCount / itemsPerPage).ceil().clamp(1, 999);

  void _previousPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
      _loadData();
    }
  }

  void _nextPage() {
    if (currentPage < totalPages) {
      setState(() => currentPage++);
      _loadData();
    }
  }

  void _showDetail(Map<String, dynamic> user) async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    final personService = PersonService(token: token);
    final roleService = RoleService(token: token);
    final addressService = AddressService(token: token);

    final person = await personService.getPersonById(user['person_id']);
    final role = await roleService.getRoleById(user['role_id']);
    final address = person != null ? await addressService.getAddressById(person['address_id']) : {};

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDetailPage(
          user: Map<String, dynamic>.from(user),
          person: Map<String, dynamic>.from(person!),
          role: Map<String, dynamic>.from(role ?? {}),
          address: Map<String, dynamic>.from(address ?? {}),
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтвердить удаление'),
        content: Text('Вы точно хотите удалить пользователя ID ${item['id']}?'),
        actions: [
          TextButton(child: Text('Отмена'), onPressed: () => Navigator.pop(context)),
          TextButton(
            child: Text('Удалить', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _users.removeWhere((e) => e['id'] == item['id']);
              });
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
        title: Text('Просмотр пользователей'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SearchFilterWidget(
            onSearchChanged: (query) {
              setState(() {
                searchQuery = query;
                currentPage = 1;
              });
              _loadData();
            },
            categories: const [],
            needDropdown: false,
            onFilterSelected: (_) {},
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final item = _users[index];
                  return Stack(
                    children: [
                      DataCard(
                        data: {
                          'ID': item['id'],
                          'Login': item['login'],
                          'Имя': item['person']?['name'] ?? '',
                          'Фамилия': item['person']?['last_name'] ?? '',
                        },
                        title: 'Пользователь',
                        onTap: () => _showDetail(item),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _showDeleteDialog(item),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          PaginationBar(
            currentPage: currentPage,
            totalPages: totalPages,
            onPrevious: _previousPage,
            onNext: _nextPage,
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child:FloatingActionButton(
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add, color: Colors.white ),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => UserEditDialog(), // без userId
              );
              _loadData();
            },
          ),
      ),
    );
  }
}
