import 'package:flutter/material.dart';

import '/_services/api_service.dart';
import '/domains/vehicle_dto.dart';

class VehicleProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<VehicleDTO> _vehicles = [];

  List<VehicleDTO> get vehicles => _vehicles;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  VehicleProvider();

  Future<void> fetchVehicles() async {
    _isLoading = true;
    _errorMessage = null;
    // notifyListeners();
    try {
      final data = await _apiService.get("/vehicles");
      _vehicles =
          data.map<VehicleDTO>((json) => VehicleDTO.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVehicle(VehicleDTO vehicle) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _apiService.post("/vehicles", body: vehicle.toJson());
      await fetchVehicles();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVehicle(VehicleDTO vehicle) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _apiService.put("/vehicles/${vehicle.id}", body: vehicle.toJson());
      await fetchVehicles();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _apiService.delete("/vehicles/$vehicleId");
      await fetchVehicles();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
