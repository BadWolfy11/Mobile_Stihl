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

// extension RequestMethodExtension on RequestMethod {
//   String get value {
//     switch (this) {
//       case RequestMethod.get:
//         return 'get';
//       case RequestMethod.post:
//         return 'post';
//       case RequestMethod.patch:
//         return 'patch';
//       case RequestMethod.put:
//         return 'put';
//       case RequestMethod.delete:
//         return 'delete';
//     }
//   }
// }

class APIResponse {
  final int status;
  final Map<String, String> headers;
  final dynamic body;

  APIResponse({
    required this.status,
    required this.headers,
    required this.body,
  });

  @override
  String toString() {
    return 'APIResponse{status: $status, headers: $headers, body: $body}';
  }
}

class API {
  final String baseUrl;
  final String? token;

  // API({this.token, this.baseUrl = 'https://backend.academytop.ru/api'}); // If need open to public
  API({this.token, this.baseUrl = 'http://192.168.72.130:8000/api'}); // Change to computer IP, if connecting from mobile/emulator.

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
      }
    }

    throw error ?? Exception('Request failed after $tries attempts');
  }

  dynamic _parseJson(String data) {
    if (kDebugMode) {
      print('DEBUG API._parseJson: $data');
    }
    try {
      return jsonDecode(data);
    } catch (e) {
      return data;
    }
  }
}