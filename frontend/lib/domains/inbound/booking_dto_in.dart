import '/domains/enums/booking_status.dart';

class BookingDTOIn {
  String? vehicleId;
  String? customerId;
  DateTime? rentalStartDate;
  DateTime? rentalEndDate;
  double? totalAmount;
  double amountPaid;
  double? remainingBalance;
  BookingStatus status;

  BookingDTOIn({
    required this.vehicleId,
    required this.customerId,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.totalAmount,
    this.amountPaid = 0.0,
    this.remainingBalance,
    this.status = BookingStatus.PENDING,
  });

  factory BookingDTOIn.fromJson(Map<String, dynamic> json) {
    return BookingDTOIn(
      vehicleId: json['vehicleId'] as String?,
      customerId: json['customerId'] as String?,
      rentalStartDate: DateTime.tryParse(json['rentalStartDate'] as String),
      rentalEndDate: DateTime.tryParse(json['rentalEndDate'] as String),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      amountPaid: (json['amountPaid'] as num?)?.toDouble() ?? 0.0,
      remainingBalance: (json['remainingBalance'] as num?)?.toDouble(),
      status: _parseBookingStatus(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'customerId': customerId,
      'rentalStartDate': rentalStartDate?.toIso8601String(),
      'rentalEndDate': rentalEndDate?.toIso8601String(),
      'totalAmount': totalAmount,
      'amountPaid': amountPaid,
      'remainingBalance': remainingBalance,
      'status': status.toString().split('.').last,
    };
  }

  static BookingStatus parseBookingStatus(String? statusString) {
    return _parseBookingStatus(statusString);
  }

  static BookingStatus _parseBookingStatus(String? statusString) {
    if (statusString == null) {
      return BookingStatus.PENDING;
    }
    switch (statusString) {
      case 'PENDING':
        return BookingStatus.PENDING;
      case 'CONFIRMED':
        return BookingStatus.CONFIRMED;
      case 'CANCELLED':
        return BookingStatus.CANCELLED;
      case 'COMPLETED':
        return BookingStatus.COMPLETED;
      default:
        return BookingStatus.PENDING;
    }
  }
}
