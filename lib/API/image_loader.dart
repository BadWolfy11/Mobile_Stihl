import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../API/API.dart';

class ImageService {
  final String token;
  late final API _api;

  ImageService({required this.token}) {
    _api = API(token: token);
  }

  Future<String?> uploadImage(File file) async {
    final uri = Uri.parse('${API.baseHost}/api/upload-image/');

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

  Future<bool> deleteImage(String path) async {
    final response = await _api.request(
      RequestMethod.delete,
      '/images/delete',
      params: {'path': path},
    );

    if (response.status == 200) {
      print('Удалено изображение: $path');
      return true;
    } else {
      print('Ошибка удаления изображения: ${response.status}');
      return false;
    }
  }
}
