import 'package:flutter/material.dart';

import 'goods_dialog.dart';

class GoodsCard extends StatelessWidget {
  final Map<String, dynamic> goods;

  const GoodsCard({required this.goods});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Image.asset(
          goods['image'],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.image),
        ),
        title: Text('${goods['id']} - ${goods['name']}'),
        subtitle: Text(goods['description']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.orange),
              onPressed: () => _showEditDialog(context, goods['id']),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

void _showEditDialog(BuildContext context, int id) {
  showDialog(
    context: context,
    builder: (context) => GoodsDialog(itemId: id),
  );
}

void _showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Подтвердить удаление'),
      content: Text('Вы точно хотите удалить этот товар?'),
      actions: [
        TextButton(
          child: Text('Отмена'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Удалить', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Товар удален (демо)')),
            );
          },
        ),
      ],
    ),
  );
}
