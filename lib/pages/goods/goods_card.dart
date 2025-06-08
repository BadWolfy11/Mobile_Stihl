import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../API/image_managment.dart';
import '../../config/user_provider.dart';
import 'good_actions.dart';
import 'goods_dialog.dart';

class GoodsCard extends StatelessWidget {
  final Map<String, dynamic> goods;
  final VoidCallback onTap;

  const GoodsCard({Key? key, required this.goods, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roleId = Provider.of<UserProvider>(context).roleId;

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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: buildNetworkImage(
                    goods['attachments'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(12),
                  )

                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${goods['id']} - ${goods['name']}',
                        style: const TextStyle(
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
                          const Text(
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
                          const Text(
                            'Кол-во: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${goods['stock']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (roleId != 1001)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _showEditDialog(context, goods['id']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            showDeleteGoodsDialog(context, goods['id'], () {}),
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
