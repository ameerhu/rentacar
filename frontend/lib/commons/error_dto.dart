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
        errorGroup: json['errorGroup'] as String,
        errorCode: json['errorCode'] as String,
        errorMessage: json['errorMessage'] as String,
        debugMessage: json['debugMessage'] as String,
        httpStatus: json['httpStatus'] as String);
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
