import 'package:flutter_test/flutter_test.dart';

import 'package:buildstock/core/utils/money.dart';

void main() {
  group('Money parsing', () {
    test('parses Indian formatted rupees into paise', () {
      expect(Money.tryParseRupees('1,250.50'), 125050);
      expect(Money.tryParseRupees('₹ 99'), 9900);
      expect(Money.tryParseRupees('0.01'), 1);
    });

    test('rejects negative and malformed input', () {
      expect(Money.tryParseRupees('-10'), isNull);
      expect(Money.tryParseRupees('abc'), isNull);
      expect(Money.tryParseRupees(''), isNull);
    });
  });

  group('Money arithmetic', () {
    test('applies basis points with half-up rounding', () {
      expect(Money.applyBps(10000, 1800), 1800);
      expect(Money.applyBps(9999, 1800), 1800);
      expect(Money.applyBps(1, 5000), 1);
      expect(Money.applyBps(0, 1800), 0);
    });

    test('formats paise for display', () {
      expect(Money.format(125050), contains('1,250.50'));
      expect(Money.plain(125050), '1250.50');
    });
  });

  group('Amount in words', () {
    test('uses the Indian numbering system', () {
      expect(Money.inWords(0), 'Rupees Zero Only');
      expect(Money.inWords(100), 'Rupees One Only');
      expect(
        Money.inWords(12345600),
        'Rupees One Lakh Twenty Three Thousand Four Hundred Fifty Six Only',
      );
      expect(Money.inWords(101), 'Rupees One and One Paise Only');
    });
  });
}
