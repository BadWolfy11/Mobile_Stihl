import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

enum RequestMethod {
  get,
  post,
  patch,
  put,
  delete,
}



class APIResponse {
  /// Класс принимающий в себя status - код ответа сервера (200,404 и тп)
  /// headers - заголовки ответа, и body - тело ответа (json, текст)
  final int status;
  final Map<String, String> headers;
  final dynamic body;

  APIResponse({
    required this.status,
    required this.headers,
    required this.body,
  });


  ///Используется для удобства просмотра ответа в консоли
  @override
  String toString() {
    return 'APIResponse{status: $status, headers: $headers, body: $body}';
  }
}
/// Класс на котором основана вся логика отправки и принятия запросов
class API {
  static const String baseHost = 'http://192.168.146.130:8000';
  final String baseUrl;
  final String? token;

  // API({this.token, this.baseUrl = 'https://backend.academytop.ru/api'}); // ссылка для публичного входа
  API({this.token, this.baseUrl = 'http://192.168.146.130:8000/api'});
  // Конструктор, который принимает токен и задает URL.

  ///Класс запросов, принимает тип запроса (get, post и тп),
  ///путь, параметры запроса, заголовки, тело и количество попыток подключения к серверу
  Future<APIResponse> request(
      RequestMethod method,
      String path, {
        Map<String, String> params = const {},
        Map<String, String> headers = const {},
        dynamic data,
        int tries = 5,
      }) async {
    Exception? error;

    for (int i = 0; i < tries; i++) {
      try {
        final uri = Uri.parse(baseUrl + path).replace(queryParameters: params);

        final requestHeaders = Map<String, String>.from(headers);
        if (token != null) {
          requestHeaders['Authorization'] = 'Bearer $token';
        }

        if (data is Map) {
          requestHeaders['Content-Type'] = 'application/json';
        }
        /// В зависимости от типа запроса отправляем нужный шаблон запроса
        http.Response response;
        switch (method) {
          case RequestMethod.get:
            response = await http.get(uri,
                headers: requestHeaders
            );
            break;
          case RequestMethod.post:
            response = await http.post(
              uri,
              headers: requestHeaders,
              //Если есть data (данные), и они — это Map, то кодируем в JSON
              body: data is Map ? jsonEncode(data) : data,
            );
            break;
          case RequestMethod.patch:
            response = await http.patch(
              uri,
              headers: requestHeaders,
              body: data is Map ? jsonEncode(data) : data,
            );
            break;
          case RequestMethod.put:
            response = await http.put(
              uri,
              headers: requestHeaders,
              body: data is Map ? jsonEncode(data) : data,
            );
            break;
          case RequestMethod.delete:
            response = await http.delete(
              uri,
              headers: requestHeaders,
              body: data is Map ? jsonEncode(data) : data,
            );
            break;
        }
        /// Возвращает ответ сервера, содержит статус ответа (200,404 и тп), заголовки ответа, и тело
        return APIResponse(
          status: response.statusCode,
          headers: response.headers,
          body: _parseJson(response.body),
        );
      } catch (e) {
        error = e as Exception;
        if (kDebugMode) {
          print('Attempt ${i + 1} failed: $e');
        }

        await Future.delayed(const Duration(milliseconds: 500));
        // Создает паузу прежде чем выполнить
        // еще одну попытку получения ответа от сервера
      }
    }

    throw error ?? Exception('Request failed after $tries attempts');
  }

  dynamic _parseJson(String data) {
    if (kDebugMode) {
      print('DEBUG API._parseJson: $data');
    }
    try {
      return jsonDecode(data); // если это JSON, вернёт объект (Map или List)
    } catch (e) {
      return data; // если это не JSON, вернёт просто строку
    }
  }
}