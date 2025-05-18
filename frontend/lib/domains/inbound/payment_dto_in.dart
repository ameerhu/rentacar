class PaymentDTOIn {
  String? customerId;
  double? totalAmount;
  String? paymentMethod;

  PaymentDTOIn({
    required this.customerId,
    required this.totalAmount,
    required this.paymentMethod,
  });

  factory PaymentDTOIn.fromJson(Map<String, dynamic> json) {
    return PaymentDTOIn(
      customerId: json["customerId"] as String,
      totalAmount: (json["totalAmount"] as num).toDouble(),
      paymentMethod: json["paymentMethod"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId,
      "totalAmount": totalAmount,
      "paymentMethod": paymentMethod,
    };
  }
}
