import '/commons/exceptions/custom_exception.dart';

class RegistrationException extends CustomException {
  RegistrationException({required super.message});

  @override
  String toString() {
    return 'RegistrationException: ${super.message}';
  }
}
