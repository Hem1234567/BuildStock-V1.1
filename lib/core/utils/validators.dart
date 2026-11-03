/// Validation shared by forms and use cases. Every rule returns null when the
/// value is valid, or a human-readable reason when it is not.
class Validators {
  const Validators._();

  static String? requiredText(String? value, {int max = 500}) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'required';
    if (text.length > max) return 'too_long';
    return null;
  }

  static String? optionalText(String? value, {int max = 2000}) {
    final text = (value ?? '').trim();
    if (text.length > max) return 'too_long';
    return null;
  }

  static String? phone(String? value, {bool required = false}) {
    final text = (value ?? '').replaceAll(RegExp(r'[\s-]'), '').trim();
    if (text.isEmpty) return required ? 'required' : null;
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(text)) return 'invalid_phone';
    return null;
  }

  static String? email(String? value, {bool required = false}) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return required ? 'required' : null;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
      return 'invalid_email';
    }
    return null;
  }

  static String? gstin(String? value, {bool required = false}) {
    final text = (value ?? '').trim().toUpperCase();
    if (text.isEmpty) return required ? 'required' : null;
    if (!RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z][1-9A-Z]Z[0-9A-Z]$').hasMatch(text)) {
      return 'invalid_gstin';
    }
    return null;
  }

  static String? pan(String? value) {
    final text = (value ?? '').trim().toUpperCase();
    if (text.isEmpty) return null;
    if (!RegExp(r'^[A-Z]{5}\d{4}[A-Z]$').hasMatch(text)) return 'invalid_pan';
    return null;
  }

  static String? pinCode(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null;
    if (!RegExp(r'^\d{6}$').hasMatch(text)) return 'invalid_pin';
    return null;
  }

  static String? amount(String? value, {bool allowZero = true}) {
    final text = (value ?? '').replaceAll(',', '').trim();
    if (text.isEmpty) return 'required';
    final parsed = double.tryParse(text);
    if (parsed == null || parsed.isNaN || parsed.isInfinite) {
      return 'invalid_number';
    }
    if (parsed < 0) return 'negative';
    if (!allowZero && parsed == 0) return 'zero';
    return null;
  }

  static String? quantity(String? value, {bool allowZero = false}) {
    final text = (value ?? '').replaceAll(',', '').trim();
    if (text.isEmpty) return 'required';
    if (!RegExp(r'^\d{0,9}(\.\d{0,3})?$').hasMatch(text)) {
      return 'invalid_number';
    }
    final parsed = double.tryParse(text);
    if (parsed == null) return 'invalid_number';
    if (parsed < 0) return 'negative';
    if (!allowZero && parsed == 0) return 'zero';
    return null;
  }

  static String? percentage(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null;
    final parsed = double.tryParse(text);
    if (parsed == null) return 'invalid_number';
    if (parsed < 0 || parsed > 100) return 'out_of_range';
    return null;
  }
}
