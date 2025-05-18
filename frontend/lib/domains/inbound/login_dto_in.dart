class LoginDtoIn {
  String? email;
  String? cnic;
  String? password;

  LoginDtoIn({required this.email, required this.password});

  factory LoginDtoIn.fromJson(Map<String, dynamic> json) {
    return LoginDtoIn(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
