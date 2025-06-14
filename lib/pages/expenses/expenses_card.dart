import 'package:flutter/material.dart';
import 'expense_actions.dart';
import 'expenses_dialog.dart';

class ExpensesCard extends StatelessWidget {
  final Map<String, dynamic> expense;
  final VoidCallback onTap;

  const ExpensesCard({
    required this.expense,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print(expense['name']);
    print(expense['attachments']);
    IconData iconData = expense['attachments'] != null ? IconData(int.parse(expense['attachments']), fontFamily: 'MaterialIcons') : Icons.money_off;
    //_getIconData(expense['attachments']);

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconData,
              size: 32,
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense['name'] ?? 'Без названия',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (expense['description'] != null)
                    Text(
                      expense['description'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () => _showEditDialog(context, expense),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => showDeleteExpenseDialog(context, expense['id'], () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Расход удален')),
                  );
                }),
              ),
            ],
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


}
