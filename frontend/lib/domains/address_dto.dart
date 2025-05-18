import '/domains/inbound/address_dto_in.dart';

class AddressDTO extends AddressDTOIn {
  String? id;

  AddressDTO(
      {this.id,
      super.city,
      super.street,
      super.state,
      super.postalCode,
      super.country});

  factory AddressDTO.fromJson(Map<String, dynamic> json) {
    return AddressDTO(
      id: json['id'] ?? '',
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? 0,
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      ...super.toJson(),
    };
  }
}
