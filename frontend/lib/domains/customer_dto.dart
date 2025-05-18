import '/domains/user_dto.dart';

class CustomerDTO extends UserDTO {
  final String cnic;
  String? phoneNumber;

  CustomerDTO(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.email,
      required this.cnic,
      this.phoneNumber});

  factory CustomerDTO.fromJson(Map<String, dynamic> json) {
    return CustomerDTO(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      cnic: json['cnic'] ?? '',
      phoneNumber: json['phoneNumber'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'cnic': cnic,
      'phoneNumber': phoneNumber,
    };
  }
}
