class PendingPaymentDTO {
  String? id;
  String? customerId;
  String? customerName;
  double? remainingBalance;

  PendingPaymentDTO({
    this.id,
    this.customerId,
    this.customerName,
    this.remainingBalance,
  });

  factory PendingPaymentDTO.fromJson(Map<String, dynamic> json) {
    return PendingPaymentDTO(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      remainingBalance: json['remainingBalance']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'remainingBalance': remainingBalance,
    };
  }
}