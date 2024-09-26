enum DataFetchExceptionReason {
  dataNotFound,
  other,
}

class DataFetchException implements Exception {
  final String message;
  final DataFetchExceptionReason reason;
  DataFetchException({
    required this.message,
    required this.reason,
  });

  @override
  String toString() => message;
}
