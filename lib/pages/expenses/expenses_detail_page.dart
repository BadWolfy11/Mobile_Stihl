import 'package:flutter/material.dart';
import '../../theme/light_color.dart';
import '../../theme/theme.dart';
import '../../widgets/title_text.dart';
import 'expenses_dialog.dart';

class ExpensesDetailPage extends StatelessWidget {
  final Map<String, dynamic> expense;

  const ExpensesDetailPage({Key? key, required this.expense}) : super(key: key);


  Widget _iconSection() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[100],
      child: Center(
        child: Icon(
          expense['icon'] ?? Icons.money_off,
          size: 100,
          color: LightColor.lightGrey,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: LightColor.grey, fontWeight: FontWeight.w800))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> expense) {
    showDialog(
      context: context,
      builder: (context) => ExpensesDialog(expense: expense),
    );
  }

  Widget _detailSection() {
    final expenseDate = DateTime.tryParse(expense['date'] ?? '') ?? DateTime.now();

    return Container(
      padding: AppTheme.padding.copyWith(top: 16, bottom: 0),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(text: expense['name'] ?? 'Без названия', fontSize: 25),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${expense['amount'] ?? 0}",
                  style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: " ₽",
                  style: TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _infoRow("Описание", expense['description'] ?? 'Нет описания'),
          _infoRow("Категория", expense['category'] ?? 'Не указано'),
          _infoRow("Дата", "${expenseDate.toLocal().toString().split(' ')[0]}"),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Удалить расход"),
        content: Text("Вы уверены, что хотите удалить этот расход?"),
        actions: [
          TextButton(
            child: Text("Отмена"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Удалить"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Расход удалён (демо)')),
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
        title: Text(expense['name'] ?? 'Детали расхода'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          _iconSection(),
          Expanded(
            child: SingleChildScrollView(
              child: _detailSection(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text('Изменить', style: TextStyle(color: Colors.white)),
                onPressed: () => _showEditDialog(context, expense),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text('Удалить', style: TextStyle(color: Colors.white)),
                onPressed: () => _showDeleteConfirmation(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
