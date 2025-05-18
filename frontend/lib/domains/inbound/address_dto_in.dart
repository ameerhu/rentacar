class AddressDTOIn {
  String? city;
  String? street;
  String? state;
  int? postalCode;
  String? country;

  AddressDTOIn({
    this.city,
    this.street,
    this.state,
    this.postalCode,
    this.country,
  });

  // Convert JSON to AddressDTOIn object
  factory AddressDTOIn.fromJson(Map<String, dynamic> json) {
    return AddressDTOIn(
      city: json['city'],
      street: json['street'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }

  // Convert AddressDTOIn object to JSON
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }
}
