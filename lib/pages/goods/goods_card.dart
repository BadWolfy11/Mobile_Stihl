import 'package:flutter/material.dart';
import 'goods_dialog.dart';

class GoodsCard extends StatelessWidget {
  final Map<String, dynamic> goods;

  final VoidCallback onTap;

  const GoodsCard({Key? key, required this.goods,  required this.onTap,}) : super(key: key);

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
            onTap: onTap, // при необходимости можно реализовать
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    goods['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${goods['id']} - ${goods['name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        goods['description'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Цена: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${goods['price']} ₽',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[700],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Кол-во: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${goods['stock']}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
          ),
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
          child: Text('Удалить', style: TextStyle(color: Colors.white)),
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
