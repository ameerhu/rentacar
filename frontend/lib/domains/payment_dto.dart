import '/domains/enums/payment_status.dart';
import '/domains/inbound/payment_dto_in.dart';

class PaymentDTO extends PaymentDTOIn {
  String? id;
  double? overpaidAmount = 0;
  DateTime? paymentDate = DateTime.now();
  PaymentStatus? paymentStatus;

  PaymentDTO({
    required this.id,
    this.overpaidAmount,
    this.paymentDate,
    this.paymentStatus,
    required super.customerId,
    required super.totalAmount,
    required super.paymentMethod,
  });

  factory PaymentDTO.fromJson(Map<String, dynamic> json) {
    return PaymentDTO(
      id: json["id"] as String,
      overpaidAmount: (json["overpaidAmount"] as num).toDouble(),
      paymentDate: DateTime.tryParse(json["paymentDate"] as String),
      paymentStatus: _parsePaymentStatus(json["paymentStatus"] as String),
      customerId: json["customerId"] as String,
      totalAmount: (json["totalAmount"] as num).toDouble(),
      paymentMethod: json["paymentMethod"],
    );
  }

  PaymentStatus parsePaymentStatus(String paymentStatus) {
    return _parsePaymentStatus(paymentStatus);
  }

  static PaymentStatus _parsePaymentStatus(String paymentStatus) {
    switch (paymentStatus) {
      case 'COMPLETED':
        return PaymentStatus.COMPLETED;
      case 'FAILED':
        return PaymentStatus.FAILED;
      default:
        return PaymentStatus.UNALLOCATED;
    }
  }
}
