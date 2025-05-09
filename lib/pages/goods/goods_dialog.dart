import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../API/goods.dart';
import '../../config/user_provider.dart';

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
  final _stockController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.itemId != null) {
      // Для реального случая — загрузить данные из API
      _nameController.text = 'Товар ${widget.itemId}';
      _descriptionController.text = 'Описание товара ${widget.itemId}';
      _barcodeController.text = '460${1000000000 + (widget.itemId! - 1)}';
      _stockController.text = '${(widget.itemId! - 1) * 5}';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _barcodeController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _saveImageLocally(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final productsDir = Directory('${appDir.path}/products');
    if (!await productsDir.exists()) {
      await productsDir.create(recursive: true);
    }

    final fileName = imageFile.path.split('/').last;
    final localPath = '${productsDir.path}/$fileName';
    final savedImage = await imageFile.copy(localPath);
    return 'assets/images/products/$fileName'; // путь для записи в БД
  }


  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    final service = GoodsService(token: token);

    final name = _nameController.text;
    // final category_id = _catego
    final description = _descriptionController.text;
    final barcode = _barcodeController.text;
    final stock = int.tryParse(_stockController.text) ?? 0;
    String? imagePath;

    if (_selectedImage != null) {
      imagePath = await _saveImageLocally(_selectedImage!);
    }

    final data = {
      'name': name,
      // 'category_id': ,
      'description': description,
      // 'price': ,
      'barcode': barcode,
      'stock': stock,
      if (imagePath != null) 'attachments': imagePath,
    };

    bool success = false;
    if (widget.itemId == null) {
      final response = await service.createGoods(data);
      success = response;
    } else {
      final response = await service.updateGoods(widget.itemId!, data);
      success = response;
    }

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.itemId == null ? 'Товар добавлен' : 'Товар обновлен')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении товара')),
      );
    }
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
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, height: 100, width: 100, fit: BoxFit.cover)
                    : Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[300],
                  child: Icon(Icons.add_a_photo, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 10),
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
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Количество на складе'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Введите количество' : null,
              ),
              const SizedBox(height: 20),
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
}
