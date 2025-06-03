import 'dart:math';

import 'package:flutter/widgets.dart';
import '/domains/pending_payment_dto.dart';

import '/_services/api_service.dart';
import '/domains/inbound/payment_dto_in.dart';
import '/domains/payment_dto.dart';

class PaymentProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  late List<PendingPaymentDTO> _pendingPayments = [];
  late List<PaymentDTO> _customerPayments = [];
  late List<PaymentDTO> _payments = [];
  String? _errorMessage;
  bool _isLoading = false;

  List<PendingPaymentDTO> get pendingPayments => _pendingPayments;

  List<PaymentDTO> get customerPayments => _customerPayments;

  List<PaymentDTO> get payments => _payments;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  fetchPayments() {
    _isLoading = true;
    _isLoading = false;
    _apiService.get("/payments").then((data) => {
          _payments = data
              .map<PaymentDTO>((json) => PaymentDTO.fromJson(json))
              .toList(),
          notifyListeners(),
          _isLoading = false,
        });
    // notifyListeners();
  }

  fetchPendingPayments() {
    _isLoading = true;
    _apiService.get("/payments/pending").then((data) => {
          _pendingPayments = data
              .map<PendingPaymentDTO>((json) => PendingPaymentDTO.fromJson(json))
              .toList(),
              notifyListeners(),
          _isLoading = false
        });
  }

  fetchPaymentsByCustomer(String customerId) {
    _isLoading = true;
    _apiService.get("/customers/$customerId/payments").then((data) => {
          _customerPayments = data
              .map<PaymentDTO>((json) => PaymentDTO.fromJson(json))
              .toList(),
              notifyListeners(),
          _isLoading = false
        });
  }

  addPayment(PaymentDTOIn payment) {
    _isLoading = true;
    customerPayments.add(PaymentDTO(
      id: Random().nextInt(1000).toString(),
      customerId: payment.customerId,
      totalAmount: payment.totalAmount,
      paymentMethod: payment.paymentMethod,
    ));
    _isLoading = false;
    _apiService.post("/payments", body: payment.toJson()).then((data) => {
          customerPayments.add(PaymentDTO.fromJson(data)),
          _isLoading = false,
        });
    notifyListeners();
  }

  Future<void> deletePayment(String paymentId) async {
    _isLoading = true;
    customerPayments.removeWhere((cp) => cp.id == paymentId);
    _isLoading = false;
    _apiService.delete("/payments").then((data) => {
          customerPayments.remove(PaymentDTO.fromJson(data)),
          _isLoading = false,
        });
  }
}
