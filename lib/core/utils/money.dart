import 'package:intl/intl.dart';

/// All monetary values in BuildStock are integer paise. This class is the only
/// place where rupees are converted for display or parsing.
class Money {
  const Money._();

  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _plain = NumberFormat('#,##0.00', 'en_IN');

  /// Parses a user-entered rupee string ("1,250.50") into paise.
  /// Returns null when the input is not a valid amount.
  static int? tryParseRupees(String? input) {
    if (input == null) return null;
    final cleaned = input.replaceAll(',', '').replaceAll('₹', '').trim();
    if (cleaned.isEmpty) return null;
    final value = double.tryParse(cleaned);
    if (value == null || value.isNaN || value.isInfinite) return null;
    if (value < 0) return null;
    return (value * 100).round();
  }

  static int parseRupees(String input) => tryParseRupees(input) ?? 0;

  /// Formats paise for display. Uses Indian digit grouping.
  static String format(int paise, {bool symbol = true}) {
    final rupees = paise / 100;
    if (!symbol) return _plain.format(rupees);
    return _inr.format(rupees);
  }

  /// Plain decimal text without grouping, suitable for PDF fields.
  static String plain(int paise) => (paise / 100).toStringAsFixed(2);

  /// Rounding helper for tax calculations; halves away from zero.
  static int roundDiv(int numerator, int denominator) {
    if (denominator == 0) return 0;
    final sign = numerator < 0 ? -1 : 1;
    final abs = numerator.abs();
    return sign * ((abs * 2 + denominator) ~/ (denominator * 2));
  }

  /// Applies a percentage expressed in basis points (1800 = 18%).
  static int applyBps(int amountPaise, int bps) =>
      roundDiv(amountPaise * bps, 10000);

  /// Indian numbering system amount in words, used on the invoice.
  static String inWords(int paise) {
    if (paise == 0) return 'Rupees Zero Only';
    final negative = paise < 0;
    final abs = paise.abs();
    final rupees = abs ~/ 100;
    final remainderPaise = abs % 100;
    final words = _numberToIndianWords(rupees);
    final buffer = StringBuffer();
    if (negative) buffer.write('Minus ');
    buffer.write('Rupees $words');
    if (remainderPaise > 0) {
      buffer.write(' and ${_numberToIndianWords(remainderPaise)} Paise');
    }
    buffer.write(' Only');
    return buffer.toString();
  }

  static String _numberToIndianWords(int number) {
    if (number == 0) return 'Zero';
    const ones = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen',
    ];
    const tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety',
    ];

    String twoDigits(int n) {
      if (n < 20) return ones[n];
      final t = n ~/ 10;
      final o = n % 10;
      return o == 0 ? tens[t] : '${tens[t]} ${ones[o]}';
    }

    String threeDigits(int n) {
      final h = n ~/ 100;
      final rest = n % 100;
      if (h == 0) return twoDigits(rest);
      final hundred = '${ones[h]} Hundred';
      return rest == 0 ? hundred : '$hundred ${twoDigits(rest)}';
    }

    final parts = <String>[];
    final crore = number ~/ 10000000;
    final lakh = (number ~/ 100000) % 100;
    final thousand = (number ~/ 1000) % 100;
    final hundreds = number % 1000;

    if (crore > 0) parts.add('${_numberToIndianWords(crore)} Crore');
    if (lakh > 0) parts.add('${twoDigits(lakh)} Lakh');
    if (thousand > 0) parts.add('${twoDigits(thousand)} Thousand');
    if (hundreds > 0) parts.add(threeDigits(hundreds));
    return parts.join(' ');
  }
}
