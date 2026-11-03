import 'package:flutter/material.dart';

import 'business_image_stub.dart' if (dart.library.io) 'business_image_io.dart';

/// Renders a locally stored business logo/signature. Network references are
/// supported on every platform; local file paths are rendered on mobile and
/// desktop through a conditional import so the web build stays valid.
Widget? businessImage(String? reference, {BoxFit fit = BoxFit.contain}) {
  if (reference == null || reference.trim().isEmpty) return null;
  final value = reference.trim();
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return Image.network(
      value,
      fit: fit,
      errorBuilder: (_, _, _) => const SizedBox.shrink(),
    );
  }
  return localBusinessImage(value, fit: fit);
}
