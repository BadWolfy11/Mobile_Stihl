import 'package:flutter/material.dart';

class ExportGoodsCard extends StatelessWidget {
  final Map<String, dynamic> goods;

  const ExportGoodsCard({Key? key, required this.goods}) : super(key: key);

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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                goods['attachments'] ?? 'assets/background.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported, size: 50),
              ),
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
                  if (goods['description'] != null)
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
                      const Text('Цена: ',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(
                        '${goods['price']} ₽',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text('Кол-во: ',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Text('${goods['stock']}', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
