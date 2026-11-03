/// Typed failures surfaced to the UI. Never swallow a failure and display a
/// fake success; every catch site either maps to one of these or rethrows.
enum FailureCode {
  validation,
  notFound,
  conflict,
  permissionDenied,
  database,
  network,
  syncNotConfigured,
  stock,
  invoiceImmutable,
  duplicate,
  unknown,
}

class AppFailure implements Exception {
  const AppFailure(this.code, this.message, {this.details, this.cause});

  final FailureCode code;
  final String message;
  final String? details;
  final Object? cause;

  bool get isRetryable =>
      code == FailureCode.network || code == FailureCode.database;

  AppFailure copyWith({String? message, String? details}) => AppFailure(
    code,
    message ?? this.message,
    details: details ?? this.details,
    cause: cause,
  );

  @override
  String toString() => 'AppFailure($code): $message';
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(String message, {super.details})
    : super(FailureCode.validation, message);
}
