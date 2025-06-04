import 'package:flutter/material.dart';
import '../API/API.dart';

String buildFullImageUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  final normalized = path.startsWith('/') ? path : '/$path';
  return '${API.baseHost}$normalized';
}


Widget buildNetworkImage(String? path, {
  double width = 100,
  double height = 100,
  BoxFit fit = BoxFit.cover,
  BorderRadius? borderRadius,
}) {
  final url = buildFullImageUrl(path);

  if (url.isEmpty) {
    return _placeholder(width, height);
  }

  final image = Image.network(
    url,
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (context, error, stackTrace) {
      return _placeholder(width, height);
    },
  );

  return borderRadius != null
      ? ClipRRect(
    borderRadius: borderRadius,
    child: image,
  )
      : image;
}

Widget _placeholder(double width, double height) {
  return Container(
    width: width,
    height: height,
    color: Colors.grey[300],
    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
  );
}
