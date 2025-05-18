class UserDTO {
  String id;
  String firstName;
  String lastName;
  String email;
  String? token;
  String? timezone;
  String? locale;

  UserDTO({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.token,
    this.timezone,
    this.locale,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      token: json['token'] as String?,
      timezone: json['timezone'] as String?,
      locale: json['locale'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'token': token,
      'timezone': timezone,
      'locale': locale,
    };
  }
}
