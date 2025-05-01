import 'package:flutter/material.dart';
import '../../theme/light_color.dart';

class ExpensesDetailPage extends StatelessWidget {
  final Map<String, dynamic> expense;

  const ExpensesDetailPage({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Преобразуем строку даты в DateTime
    DateTime expenseDate = DateTime.parse(expense['date']);

    return Scaffold(
      appBar: AppBar(
        title: Text(expense['name'] ?? 'Без названия'),
        backgroundColor: LightColor.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Описание: ${expense['description'] ?? 'Нет описания'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Сумма: ${expense['amount'] ?? 0} ₽',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Категория: ${expense['category'] ?? 'Не указано'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Преобразуем строку в дату и выводим локализованную дату
            Text(
              'Дата: ${expenseDate.toLocal().toString()}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
