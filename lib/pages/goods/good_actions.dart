import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../API/goods.dart';
import '../../config/user_provider.dart';
import '../goods/goods_dialog.dart';

void showEditGoodsDialog(BuildContext context, int id) {
  showDialog(
    context: context,
    builder: (context) => GoodsDialog(itemId: id),
  );
}

void showDeleteGoodsDialog(BuildContext context, int id, VoidCallback onDeleted) {
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text('Удалить', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            Navigator.pop(context);
            final token = Provider.of<UserProvider>(context, listen: false).token;
            if (token == null) return;

            final service = GoodsService(token: token);
            final success = await service.deleteGoods(id);

            if (success) {
              onDeleted();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Товар удалён')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка при удалении')),
              );
            }
          },
        ),
      ],
    ),
  );
}
