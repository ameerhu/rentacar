class ErrorDTO {
  String errorGroup;
  String errorCode;
  String errorMessage;
  String debugMessage;
  String httpStatus;

  ErrorDTO({
    required this.errorGroup,
    required this.errorCode,
    required this.errorMessage,
    required this.debugMessage,
    required this.httpStatus,
  });

  factory ErrorDTO.fromJson(Map<String, dynamic> json) {
    return ErrorDTO(
        errorGroup: json['errorGroup'] ?? '',
        errorCode: json['errorCode'] ?? '',
        errorMessage: json['errorMessage'] ?? '',
        debugMessage: json['debugMessage'] ?? '',
        httpStatus: json['httpStatus'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'errorGroup': errorGroup,
      'errorCode': errorCode,
      'errorMessage': errorMessage,
      'debugMessage': debugMessage,
      'httpStatus': httpStatus,
    };
  }

  @override
  String toString() {
    return errorMessage;
  }
}
