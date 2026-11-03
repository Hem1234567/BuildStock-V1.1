import 'dart:math';

import 'package:uuid/uuid.dart';

/// Stable, prefixed identifiers make sync logs and Firestore documents
/// self-describing, and make collisions across offline devices negligible.
class Ids {
  const Ids._();

  static const _uuid = Uuid();

  static String newId(String prefix) =>
      '${prefix}_${_uuid.v4().replaceAll('-', '')}';

  static String product() => newId('prd');
  static String sale() => newId('inv');
  static String saleItem() => newId('sli');
  static String customer() => newId('cus');
  static String supplier() => newId('sup');
  static String store() => newId('str');
  static String godown() => newId('gdn');
  static String staff() => newId('stf');
  static String driver() => newId('drv');
  static String vehicle() => newId('veh');
  static String purchase() => newId('pur');
  static String purchaseItem() => newId('pli');
  static String payment() => newId('pay');
  static String expense() => newId('exp');
  static String expenseCategory() => newId('exc');
  static String stockMovement() => newId('stm');
  static String stockTransfer() => newId('stt');
  static String stockTransferItem() => newId('sti');
  static String salary() => newId('sal');
  static String salaryPayment() => newId('slp');
  static String delivery() => newId('dlv');
  static String deliveryItem() => newId('dli');
  static String deliveryProof() => newId('dlp');
  static String attendance() => newId('att');
  static String audit() => newId('aud');
  static String queue() => newId('que');
  static String operation() => newId('op');
  static String image() => newId('img');
  static String category() => newId('cat');
  static String brand() => newId('brd');
  static String unit() => newId('unt');
  static String returnDoc() => newId('ret');
  static String order() => newId('ord');
  static String priceList() => newId('prl');

  /// Deterministic inventory row ID from product + location.
  static String inventoryKey({
    required String productId,
    String? storeId,
    String? godownId,
  }) => '$productId:${storeId ?? ''}:${godownId ?? ''}';

  /// Payment idempotency key. Retrying the same offline operation reuses it.
  static String paymentIdempotencyKey({
    required String deviceId,
    required String clientReference,
  }) => 'pay-$deviceId-$clientReference';

  /// Device codes are short, uppercase and safe inside invoice numbers.
  static String deviceCodeFromName(String name) {
    final cleaned = name.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (cleaned.isEmpty) return 'DEVICE01';
    return cleaned.length <= 10 ? cleaned : cleaned.substring(0, 10);
  }

  static String randomCode(int length) {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => alphabet[random.nextInt(alphabet.length)],
    ).join();
  }
}

/// Invoice numbers are device-aware so two offline devices can never produce
/// the same number: VBA-2026-DEVICE01-000001.
class InvoiceNumber {
  const InvoiceNumber._();

  static String build({
    required String prefix,
    required DateTime date,
    required String deviceCode,
    required int sequence,
  }) {
    final year = date.year;
    final code = Ids.deviceCodeFromName(deviceCode);
    return '$prefix-$year-$code-${sequence.toString().padLeft(6, '0')}';
  }

  static String sequenceKey({
    required String documentType,
    required String deviceCode,
    required DateTime date,
  }) => '$documentType:${Ids.deviceCodeFromName(deviceCode)}:${date.year}';
}
