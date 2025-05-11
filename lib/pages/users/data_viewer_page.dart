import 'package:flutter/material.dart';
import '../../widgets/search_filter.dart';
import '../../widgets/pagination_bar.dart';
import 'data_card.dart';
import '../profile/models.dart';
import 'data_detail_page.dart';

class DataViewerPage extends StatefulWidget {
  @override
  _DataViewerPageState createState() => _DataViewerPageState();
}

class _DataViewerPageState extends State<DataViewerPage> {
  String selectedSource = 'users';
  String searchQuery = '';
  int currentPage = 1;
  final int itemsPerPage = 10;

  final Map<String, List<Map<String, dynamic>>> allDataSources = {
    'users': users,
    'persons': persons,
    'roles': roles,
    'addresses': addresses,
    'documents': documents,
    'documentTypes': documentTypes,
  };

  final Map<String, String> dataTitles = {
    'users': 'Пользователи',
    'persons': 'Персоны',
    'roles': 'Роли',
    'addresses': 'Адреса',
    'documents': 'Документы',
    'documentTypes': 'Типы документов',
  };

  List<Map<String, dynamic>> get currentData =>
      (allDataSources[selectedSource] ?? [])
          .where((item) => item.entries.any((e) =>
          e.value.toString().toLowerCase().contains(searchQuery.toLowerCase())))
          .toList();

  int get totalPages => (currentData.length / itemsPerPage).ceil().clamp(1, 999);

  void _previousPage() {
    if (currentPage > 1) setState(() => currentPage--);
  }

  void _nextPage() {
    if (currentPage < totalPages) setState(() => currentPage++);
  }

  void _showDetail(Map<String, dynamic> user) {
    final person = persons.firstWhere((p) => p['id'] == user['person_id'], orElse: () => {});
    final role = roles.firstWhere((r) => r['id'] == user['role_id'], orElse: () => {});
    final address = addresses.firstWhere((a) => a['id'] == person['address_id'], orElse: () => {});
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDetailPage(
          user: user,
          person: person,
          role: role,
          address: address,
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтвердить удаление'),
        content: Text('Вы точно хотите удалить элемент ID ${item['id']}?'),
        actions: [
          TextButton(child: Text('Отмена'), onPressed: () => Navigator.pop(context)),
          TextButton(
            child: Text('Удалить', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                allDataSources[selectedSource]!.removeWhere((e) => e['id'] == item['id']);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pagedData = currentData.skip((currentPage - 1) * itemsPerPage).take(itemsPerPage).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Просмотр данных'),
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
            },
            onFilterSelected: (value) {
              setState(() {
                selectedSource = value;
                currentPage = 1;
              });
            },
            categories: allDataSources.keys.toList(),
            needDropdown: false,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pagedData.length,
              itemBuilder: (context, index) {
                final item = pagedData[index];
                return Stack(
                  children: [
                    DataCard(
                      data: item,
                      title: dataTitles[selectedSource] ?? selectedSource,
                      onTap: selectedSource == 'users' ? () => _showDetail(item) : null,
                    ),
                    if (selectedSource == 'users')
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
    );
  }
}
