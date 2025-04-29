import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:barcode_widget/barcode_widget.dart';

class BarcodeWithCopyButton extends StatefulWidget {
  final String data;
  final double width;
  final double height;

  const BarcodeWithCopyButton({
    super.key,
    required this.data,
    this.width = 200,
    this.height = 80,
  });

  @override
  State<BarcodeWithCopyButton> createState() => _BarcodeWithCopyButtonState();
}

class _BarcodeWithCopyButtonState extends State<BarcodeWithCopyButton> {
  final GlobalKey _barcodeKey = GlobalKey();

  Barcode _determineBarcodeType() {
    final data = widget.data;
    final isLikelyQR = data.length > 20 || data.contains(RegExp(r'[A-Za-z]'));
    return isLikelyQR ? Barcode.qrCode() : Barcode.code128();
  }

  Future<void> _copyBarcodeAsImage() async {
    try {
      RenderRepaintBoundary boundary =
      _barcodeKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/barcode.png';
      final file = File(imagePath);
      await file.writeAsBytes(pngBytes);

      await Clipboard.setData(ClipboardData(text: widget.data));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Код скопирован')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.baseline,
      // textBaseline: TextBaseline.alphabetic,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        RepaintBoundary(
          key: _barcodeKey,
          child: BarcodeWidget(
            barcode: _determineBarcodeType(),
            data: widget.data,
            width: widget.width,
            height: widget.height,
          ),
        ),
        SizedBox(width: 30),
        Padding(padding: EdgeInsets.only(bottom: 20),
        child:
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            icon: Icon(Icons.copy, color: Colors.black54),
            onPressed: _copyBarcodeAsImage,
            tooltip: 'Скопировать код',
          ),
        )

        ),


      ],
    );
  }
}
