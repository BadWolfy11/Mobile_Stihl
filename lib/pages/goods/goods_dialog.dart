import 'package:flutter/material.dart';

class GoodsDialog extends StatefulWidget {
  final int? itemId;

  const GoodsDialog({this.itemId});

  @override
  _GoodsDialogState createState() => _GoodsDialogState();
}

class _GoodsDialogState extends State<GoodsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _barcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Для демо - заполняем поля если это редактирование
    if (widget.itemId != null) {
      _nameController.text = 'Товар ${widget.itemId}';
      _descriptionController.text = 'Описание товара ${widget.itemId}';
      _barcodeController.text = '460${1000000000 + (widget.itemId! - 1)}';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.itemId == null ? 'Добавить товар' : 'Редактировать товар'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Название'),
                validator: (value) => value!.isEmpty ? 'Введите название' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Описание'),
              ),
              TextFormField(
                controller: _barcodeController,
                decoration: InputDecoration(labelText: 'Штрихкод'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: Text('Сохранить'),
                    onPressed: _saveForm,
                  ),
                  TextButton(
                    child: Text('Отмена'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.itemId == null
              ? 'Товар добавлен (демо)'
              : 'Товар обновлен (демо)'),
        ),
      );
    }
  }
}