import 'package:flutter/material.dart';

class ExportExpensesCard extends StatelessWidget {
  final Map<String, dynamic> expense;

  const ExportExpensesCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    IconData iconData = expense['attachments'] != null
        ? IconData(int.tryParse(expense['attachments'].toString()) ?? 0xe57f, fontFamily: 'MaterialIcons')
        : Icons.money_off;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, size: 32, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense['name'] ?? 'Без названия',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (expense['description'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      expense['description'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Сумма: ${expense['amount']} ₽',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Категория: ${expense['expense_category_id'] ?? 'Не указано'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
