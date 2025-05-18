import 'package:flutter/material.dart';

import '../_services/api_service.dart';
import '../domains/customer_dto.dart';

class CustomerProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<CustomerDTO> _customers = [];
  CustomerDTO? selectedCustomer;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  List<CustomerDTO> get customers => _customers;

  void setSelectedCustomer(CustomerDTO? customer) {
    selectedCustomer = customer;
    notifyListeners();
  }

  Future<void> fetchCustomers() async {
    _isLoading = true;
    final data = await _apiService.get('/customers');
    _customers =
        data.map<CustomerDTO>((json) => CustomerDTO.fromJson(json)).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCustomer(CustomerDTO customer) async {
    _isLoading = true;
    final newCustomer =
        await _apiService.post('/customers', body: customer.toJson());
    _customers.add(CustomerDTO.fromJson(newCustomer));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateCustomer(String id, CustomerDTO customer) async {
    _isLoading = true;
    try {
      await _apiService.put('/customers/$id', body: customer.toJson());
      int index = _customers.indexWhere((customer) => customer.id == id);
      _customers.removeAt(index);
      _customers.insert(index, customer);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(String id) async {
    _isLoading = true;
    try {
      await _apiService.delete('/customers/$id');
      _customers.removeWhere((customer) => customer.id == id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
