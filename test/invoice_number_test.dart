import 'package:flutter_test/flutter_test.dart';

import 'package:buildstock/core/utils/ids.dart';

void main() {
  group('Invoice numbers', () {
    test('are device-aware, year-scoped and zero padded', () {
      final number = InvoiceNumber.build(
        prefix: 'VBA',
        date: DateTime(2026, 4, 1),
        deviceCode: 'device 01',
        sequence: 1,
      );
      expect(number, 'VBA-2026-DEVICE01-000001');
    });

    test('sanitises device codes', () {
      expect(Ids.deviceCodeFromName('Front Counter #2'), 'FRONTCOUNT');
      expect(Ids.deviceCodeFromName(''), 'DEVICE01');
    });

    test('different devices cannot collide for the same sequence', () {
      final a = InvoiceNumber.build(
        prefix: 'VBA',
        date: DateTime(2026),
        deviceCode: 'AAA',
        sequence: 42,
      );
      final b = InvoiceNumber.build(
        prefix: 'VBA',
        date: DateTime(2026),
        deviceCode: 'BBB',
        sequence: 42,
      );
      expect(a, isNot(b));
    });

    test('sequence keys isolate document type, device and year', () {
      final key = InvoiceNumber.sequenceKey(
        documentType: 'invoice',
        deviceCode: 'DEV1',
        date: DateTime(2026, 12, 31),
      );
      expect(key, 'invoice:DEV1:2026');
    });
  });

  group('Ids', () {
    test('inventory keys are deterministic', () {
      expect(
        Ids.inventoryKey(productId: 'p1', storeId: 's1', godownId: 'g1'),
        'p1:s1:g1',
      );
      expect(Ids.inventoryKey(productId: 'p1'), 'p1::');
    });

    test('generated identifiers are prefixed and unique', () {
      final first = Ids.product();
      final second = Ids.product();
      expect(first.startsWith('prd_'), isTrue);
      expect(first, isNot(second));
    });
  });
}
