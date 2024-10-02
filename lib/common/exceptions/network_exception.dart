class NetworkException implements Exception {
  final String? message;
  NetworkException(this.message);

  @override
  String toString() => message ?? 'Cannot connect to the server';
}
