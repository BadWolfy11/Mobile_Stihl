import 'package:flutter/material.dart';
import '../../API/expenses.dart';
import '../../config/user_provider.dart';
import 'package:provider/provider.dart';

void showDeleteExpenseDialog(BuildContext context, int expenseId, VoidCallback onSuccess) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Удалить расход'),
      content: const Text('Вы уверены, что хотите удалить этот расход?'),
      actions: [
        TextButton(
          child: const Text('Отмена'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Удалить', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            final token = Provider.of<UserProvider>(context, listen: false).token;
            if (token != null) {
              final service = ExpensesService(token: token);
              final success = await service.deleteExpense(expenseId);
              if (success) {
                Navigator.pop(context);
                onSuccess();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ошибка при удалении')),
                );
              }
            }
          },
        ),
      ],
    ),
  );
}
