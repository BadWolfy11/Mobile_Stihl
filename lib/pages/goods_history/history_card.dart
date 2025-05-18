import 'package:flutter/material.dart';

class GoodsHistoryCard extends StatelessWidget {
  final Map<String, dynamic> history;

  const GoodsHistoryCard({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${history['id']}  |  Товар: ${history['goods_id']}  |  Пользователь: ${history['user_id']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text('Поле: ${history['field_changed']}'),
            Text('Старое значение: ${history['old_value'] ?? "-"}'),
            Text('Новое значение: ${history['new_value'] ?? "-"}'),
            Text('Действие: ${history['action']}'),
            Text('Дата: ${history['changed_at']}'),
          ],
        ),
      ),
    );
  }
}
