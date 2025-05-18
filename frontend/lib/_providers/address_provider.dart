import 'package:flutter/material.dart';

import '../_services/api_service.dart';
import '../domains/address_dto.dart';
import '../domains/inbound/address_dto_in.dart';

class AddressProvider with ChangeNotifier {
  final ApiService _service = ApiService();
  List<AddressDTO> _addresses = [];
  AddressDTO? customerAddress;

  List<AddressDTO> get addresses => _addresses;

  Future<void> loadAddresses() async {
    _addresses = await _service.get("/address");
    notifyListeners();
  }

  Future<void> addAddress(String cId, AddressDTOIn address) async {
    final data =
        await _service.post("/customers/$cId/address", body: address.toJson());
    _addresses.add(AddressDTO.fromJson(data));
    notifyListeners();
  }

  Future<void> updateAddress(String id, AddressDTO address) async {
    AddressDTO updatedAddress =
        await _service.put("/customers/$id/address", body: address.toJson());
    int index = _addresses.indexWhere((addr) => addr.postalCode == id);
    if (index != -1) {
      _addresses[index] = updatedAddress;
      notifyListeners();
    }
  }

  Future<void> removeAddress(String cId, String aId) async {
    await _service.delete("/customers/$cId/address/$aId");
    _addresses.removeWhere((addr) => addr.postalCode == aId);
    notifyListeners();
  }

  Future<void> setCustomerId(String id) async {
    var data = await _service.get("/customers/$id/address");
    customerAddress = null;
    if (data != null && data.isNotEmpty)
      customerAddress = AddressDTO.fromJson(data);
    notifyListeners();
  }
}
