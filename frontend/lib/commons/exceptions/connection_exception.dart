import '/commons/exceptions/custom_exception.dart';

class ConnectionException extends CustomException {
  ConnectionException({required super.message});

  @override
  String toString() {
    return 'ConnectionException: ${super.message}';
  }
}
