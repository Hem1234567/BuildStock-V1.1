import 'package:flutter_test/flutter_test.dart';

import 'package:buildstock/core/utils/quantity.dart';

void main() {
  group('Quantity parsing', () {
    test('parses decimals into milli-units exactly', () {
      expect(Quantity.tryParseMilli('1'), 1000);
      expect(Quantity.tryParseMilli('1.5'), 1500);
      expect(Quantity.tryParseMilli('1.25'), 1250);
      expect(Quantity.tryParseMilli('0.001'), 1);
      expect(Quantity.tryParseMilli('1,200.75'), 1200750);
    });

    test('rejects more than three decimals and invalid input', () {
      expect(Quantity.tryParseMilli('1.2345'), isNull);
      expect(Quantity.tryParseMilli('abc'), isNull);
      expect(Quantity.tryParseMilli(''), isNull);
    });
  });

  group('Quantity formatting', () {
    test('trims trailing zeroes', () {
      expect(Quantity.format(1000), '1');
      expect(Quantity.format(1500), '1.5');
      expect(Quantity.format(1250), '1.25');
      expect(Quantity.format(1), '0.001');
    });

    test('supports Indian grouping', () {
      expect(Quantity.format(1200000, grouping: true), '1,200');
    });
  });
}
