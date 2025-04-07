// Custom exception class for unlock errors
class UnlockException implements Exception {
  final String message;
  UnlockException(this.message);

  @override
  String toString() => message;
}