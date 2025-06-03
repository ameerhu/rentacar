import 'package:frontend/domains/booking_dto.dart';

import '/domains/enums/booking_status.dart';
import '/domains/inbound/booking_dto_in.dart';

class BookingDTOEXT extends BookingDTO {
  String? vehicleName;
  String? customerName;

  BookingDTOEXT({
    required super.id,
    required super.vehicleId,
    required this.vehicleName,
    required super.customerId,
    required this.customerName,
    required super.rentalStartDate,
    required super.rentalEndDate,
    required super.totalAmount,
    super.amountPaid = 0.0,
    super.remainingBalance,
    super.status = BookingStatus.PENDING,
  });

  factory BookingDTOEXT.fromJson(Map<String, dynamic> json) {
    return BookingDTOEXT(
      id: json['id'] as String?,
      vehicleId: json['vehicleId'] as String?,
      vehicleName: json['vehicleName'] as String?,
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      rentalStartDate:
          DateTime.fromMillisecondsSinceEpoch(json['rentalStartDate'] as int),
      rentalEndDate:
          DateTime.fromMillisecondsSinceEpoch(json['rentalEndDate'] as int),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      amountPaid: (json['amountPaid'] as num?)?.toDouble() ?? 0.0,
      remainingBalance: (json['remainingBalance'] as num?)?.toDouble(),
      status: BookingDTOIn.parseBookingStatus(json['status']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'customerId': customerId,
      'customerName': customerName,
      'rentalStartDate': rentalStartDate?.toIso8601String(),
      'rentalEndDate': rentalEndDate?.toIso8601String(),
      'totalAmount': totalAmount,
      'amountPaid': amountPaid,
      'remainingBalance': remainingBalance,
      'status': status.toString().split('.').last,
    };
  }
}
