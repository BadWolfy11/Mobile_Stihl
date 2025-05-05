import 'package:flutter/material.dart';
import 'package:stihl_mobile/theme/light_color.dart';

import '../profile/models.dart';
import 'data_card.dart';
import '../../widgets/search_filter.dart';
import '../../widgets/pagination_bar.dart';

class DataViewerPage extends StatefulWidget {
  @override
  _DataViewerPageState createState() => _DataViewerPageState();
}

class _DataViewerPageState extends State<DataViewerPage> {
  String selectedSource = 'users';
  String searchQuery = '';
  int currentPage = 1;
  final int itemsPerPage = 10;

  List<Map<String, dynamic>> get currentData =>
      (allDataSources[selectedSource] ?? [])
          .where((item) => item.entries.any((e) =>
          e.value.toString().toLowerCase().contains(searchQuery.toLowerCase())))
          .toList();

  final Map<String, List<Map<String, dynamic>>> allDataSources = {
    'users': users,
    'persons': persons,
    'addresses': addresses,
    'documents': documents,
    'documentTypes': documentTypes,
  };

  final Map<String, String> dataTitles = {
    'users': 'Пользователи',
    'persons': 'Персоны',
    'addresses': 'Адреса',
    'documents': 'Документы',
    'documentTypes': 'Типы документов',
  };

  int get totalPages => (currentData.length / itemsPerPage).ceil().clamp(1, 999);

  void _previousPage() {
    if (currentPage > 1) setState(() => currentPage--);
  }

  void _nextPage() {
    if (currentPage < totalPages) setState(() => currentPage++);
  }

  void _showEditDialog(Map<String, dynamic> item) {
    // TODO: реализовать диалог редактирования
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Редактирование элемента ID ${item['id']} (демо)')),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтвердить удаление'),
        content: Text('Вы точно хотите удалить элемент ID ${item['id']}?'),
        actions: [
          TextButton(
            child: Text('Отмена'),
            onPressed: () => Navigator.pop(context),
          ),
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
    final pagedData = currentData
        .skip((currentPage - 1) * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(dataTitles[selectedSource] ?? 'Данные'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          DropdownButton<String>(
            value: selectedSource,
            dropdownColor: Colors.white,
            underline: SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedSource = value;
                  currentPage = 1;
                });
              }
            },
            items: allDataSources.keys.map((source) {
              return DropdownMenuItem(
                value: source,
                child: Text(dataTitles[source] ?? source),
              );
            }).toList(),
          ),
          SizedBox(width: 8),
        ],
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
            onFilterSelected: (value) {},
            categories: allDataSources.keys.toList(),
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
                      onTap: () {},
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showEditDialog(item),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _showDeleteDialog(item),
                          ),
                        ],
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