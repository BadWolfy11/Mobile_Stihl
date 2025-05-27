import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../API/API.dart';

class ImageService {
  final String token;

  ImageService({required this.token});

  Future<String?> uploadImage(File file) async {
    final uri = Uri.parse('${API.baseHost}/upload-image/');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);
      return data['url'];
    }

    print('Ошибка загрузки изображения: ${response.statusCode}');
    return null;
  }
}
