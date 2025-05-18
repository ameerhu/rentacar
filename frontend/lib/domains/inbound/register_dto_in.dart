import '/domains/gender.dart';

class RegisterDtoIn {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  Gender? gender;
  String? password;

  RegisterDtoIn({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.password,
  });

  factory RegisterDtoIn.fromJson(Map<String, dynamic> json) {
    return RegisterDtoIn(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      gender: json['gender'] != null
          ? Gender.values.byName(json['gender'] as String)
          : null,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender?.name,
      'password': password,
    };
  }
}
