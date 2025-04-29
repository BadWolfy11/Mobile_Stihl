import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    const buttonWidth = 100.0; // Задаём фиксированную ширину кнопок

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: buttonWidth,
            child: currentPage > 1
                ? ElevatedButton(
              onPressed: onPrevious,
              child: Text('Назад'),
            )
                : ElevatedButton(
              onPressed: null, // неактивная кнопка
              child: Text('Назад'),
            ),
          ),
          SizedBox(width: 20),
          Text('Страница $currentPage из $totalPages'),
          SizedBox(width: 20),
          SizedBox(
            width: buttonWidth,
            child: currentPage < totalPages
                ? ElevatedButton(
              onPressed: onNext,
              child: Text('Вперед'),
            )
                : ElevatedButton(
              onPressed: null, // неактивная кнопка
              child: Text('Вперед'),
            ),
          ),
        ],
      ),
    );
  }
}
