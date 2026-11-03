/// Quantities are integer milli-units everywhere (3 decimal places), which
/// keeps inventory arithmetic exact for tonnes, cubic feet, bags and pieces.
class Quantity {
  const Quantity._();

  static const int milliPerUnit = 1000;

  /// Parses "1", "1.5", "1.250" into milli-units. Returns null when invalid.
  static int? tryParseMilli(String? input) {
    if (input == null) return null;
    final cleaned = input.replaceAll(',', '').trim();
    if (cleaned.isEmpty) return null;
    final match = RegExp(r'^(\d{0,12})(?:\.(\d{0,3}))?$').firstMatch(cleaned);
    if (match == null) return null;
    final whole = int.tryParse(match.group(1) ?? '') ?? 0;
    final fractionText = (match.group(2) ?? '').padRight(3, '0');
    final fraction = int.tryParse(fractionText) ?? 0;
    if (whole == 0 && fraction == 0 && !cleaned.contains('0')) return null;
    return whole * milliPerUnit + fraction;
  }

  static int parseMilli(String input) => tryParseMilli(input) ?? 0;

  static int fromUnits(num units) => (units * milliPerUnit).round();

  static double toDouble(int milli) => milli / milliPerUnit;

  /// Formats without unnecessary trailing zeroes: 1250 -> "1.25".
  static String format(
    int milli, {
    int maxDecimals = 3,
    bool grouping = false,
  }) {
    final negative = milli < 0;
    final abs = milli.abs();
    final whole = abs ~/ milliPerUnit;
    final fraction = abs % milliPerUnit;
    var text = whole.toString();
    if (grouping) {
      text = _groupIndian(whole);
    }
    if (fraction > 0 && maxDecimals > 0) {
      var frac = fraction.toString().padLeft(3, '0');
      if (maxDecimals < 3) frac = frac.substring(0, maxDecimals);
      frac = frac.replaceFirst(RegExp(r'0+$'), '');
      if (frac.isNotEmpty) text = '$text.$frac';
    }
    return negative ? '-$text' : text;
  }

  static String _groupIndian(int value) {
    final digits = value.toString();
    if (digits.length <= 3) return digits;
    final last3 = digits.substring(digits.length - 3);
    var rest = digits.substring(0, digits.length - 3);
    final groups = <String>[];
    while (rest.length > 2) {
      groups.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) groups.insert(0, rest);
    return '${groups.join(',')},$last3';
  }
}
