import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

import 'dart:ui' as ui;

class ShareScreenHelper {
  static Future<void> capturePng(BuildContext context,
      {required bool mounted, required GlobalKey globalKey}) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    if (kDebugMode) {
      print("Waiting for boundary to be painted.");
    }
    // await Future.delayed(const Duration(milliseconds: 20));
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData!.buffer.asUint8List();
    if (kDebugMode) {
      print(pngBytes);
    }
    if (mounted) {
      _onShareXFileFromAssets(context, byteData);
    }
  }

  static void _onShareXFileFromAssets(
      BuildContext context, ByteData? data) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // final data = await rootBundle.load('assets/flutter_logo.png');
    final buffer = data!.buffer;
    final shareResult = await Share.shareXFiles(
      [
        XFile.fromData(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          name: 'screen_shot.png',
          mimeType: 'image/png',
        ),
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  static SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }
}
