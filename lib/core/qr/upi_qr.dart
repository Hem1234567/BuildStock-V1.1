/// UPI intent and invoice reference QR payloads.
///
/// BuildStock does not integrate a payment gateway. The UPI QR only *requests*
/// a payment in the customer's own UPI application; the business must record
/// the payment manually after confirming receipt.
abstract final class UpiQr {
  static String paymentUri({
    required String upiId,
    required String payeeName,
    required int amountPaise,
    String? invoiceNumber,
    String? invoiceId,
    String? note,
  }) {
    final amount = (amountPaise / 100).toStringAsFixed(2);
    final params = <String, String>{
      'pa': upiId.trim(),
      'pn': payeeName.trim().isEmpty ? 'Business' : payeeName.trim(),
      'am': amount,
      'cu': 'INR',
      if (invoiceNumber != null && invoiceNumber.isNotEmpty)
        'tn': note ?? 'Invoice $invoiceNumber',
      if (invoiceId != null && invoiceId.isNotEmpty) 'tr': invoiceId,
    };
    return Uri(scheme: 'upi', host: 'pay', queryParameters: params).toString();
  }

  /// A compact identifier only. No customer name, phone or amount is exposed.
  static String invoiceReferenceUri(String invoiceId) => Uri(
    scheme: 'buildstock',
    host: 'invoice',
    path: '/$invoiceId',
  ).toString();
}

abstract final class InvoiceReference {
  static const String scheme = 'buildstock';
  static const String host = 'invoice';

  /// Returns the invoice ID when [value] is a BuildStock invoice reference.
  static String? parse(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null || uri.scheme != scheme || uri.host != host) return null;
    final segments = uri.pathSegments.where((part) => part.isNotEmpty).toList();
    if (segments.isEmpty) return null;
    return segments.first;
  }
}
