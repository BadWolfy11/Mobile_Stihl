import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../API/goods_history.dart';
import '../../config/user_provider.dart';
import '../../widgets/pagination_bar.dart';
import 'history_card.dart';

class GoodsHistoryPage extends StatefulWidget {
  @override
  _GoodsHistoryPageState createState() => _GoodsHistoryPageState();
}

class _GoodsHistoryPageState extends State<GoodsHistoryPage> {
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  List<Map<String, dynamic>> _history = [];
  int _totalCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    setState(() => _isLoading = true);
    final service = GoodsHistoryService(token: token);
    final data = await service.searchGoodsHistory(
      offset: (_currentPage - 1) * _itemsPerPage,
      limit: _itemsPerPage,
    );

    setState(() {
      _history = List<Map<String, dynamic>>.from(data['items']);
      _totalCount = data['totalCount'] ?? 0;
      _isLoading = false;
    });
  }

  int get _totalPages => (_totalCount / _itemsPerPage).ceil().clamp(1, 999);

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() => _currentPage--);
      _loadHistory();
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() => _currentPage++);
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История изменений товаров'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return GoodsHistoryCard(history: item);

              },
            ),
          ),
          PaginationBar(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPrevious: _previousPage,
            onNext: _nextPage,
          ),
        ],
      ),
    );
  }
}
