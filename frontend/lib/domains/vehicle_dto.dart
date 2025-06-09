import '/domains/enums/vehicle_status.dart';

class VehicleDTO {
  String? id;
  String? company;
  String? model;
  String? type;
  String? licensePlate;
  String? number;
  VehicleStatus status;
  String? ownerId;
  String? ownerName;
  double? pricePerDay;

  VehicleDTO({
    this.id,
    this.company,
    this.model,
    this.type,
    this.licensePlate,
    this.number,
    this.status = VehicleStatus.AVAILABLE,
    this.ownerId,
    this.ownerName,
    this.pricePerDay,
  });

  factory VehicleDTO.fromJson(Map<String, dynamic> json) {
    return VehicleDTO(
      id: json['id'] as String?,
      company: json['company'] as String?,
      model: json['model'] as String?,
      type: json['type'] as String?,
      licensePlate: json['licensePlate'] as String?,
      number: json['number'] as String?,
      status: _parseVehicleStatus(json['status']),
      ownerId: json['ownerId'] as String?,
      ownerName: json['ownerName'] as String?,
      pricePerDay: (json['pricePerDay'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'model': model,
      'type': type,
      'licensePlate': licensePlate,
      'number': number,
      'status': status.toString().split('.').last,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'pricePerDay': pricePerDay,
    };
  }

  static VehicleStatus _parseVehicleStatus(String? statusString) {
    if (statusString == null) {
      return VehicleStatus.AVAILABLE;
    }
    switch (statusString) {
      case 'AVAILABLE':
        return VehicleStatus.AVAILABLE;
      case 'BOOKED':
        return VehicleStatus.BOOKED;
      case 'OUTOFSERVICE':
        return VehicleStatus.OUTOFSERVICE;
      case 'UNAVAILABLE':
        return VehicleStatus.UNAVAILABLE;
      default:
        return VehicleStatus.AVAILABLE;
    }
  }
}
