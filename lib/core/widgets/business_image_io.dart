import 'dart:io';

import 'package:flutter/material.dart';

Widget? localBusinessImage(String path, {BoxFit fit = BoxFit.contain}) {
  try {
    final file = File(path);
    if (!file.existsSync()) return null;
    return Image.file(
      file,
      fit: fit,
      errorBuilder: (_, _, _) => const SizedBox.shrink(),
    );
  } catch (_) {
    return null;
  }
}
