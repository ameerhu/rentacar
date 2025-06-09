import 'package:flutter/material.dart';
import 'package:frontend/domains/booking_dto_ext.dart';

import '/_services/api_service.dart';
import '/domains/booking_dto.dart';
import '/domains/inbound/booking_dto_in.dart';

class BookingProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<BookingDTOEXT> _bookings = [];
  List<BookingDTOEXT> _customerBookings = [];

  List<BookingDTOEXT> get bookings => _bookings;
  List<BookingDTOEXT> get customerBookings => _customerBookings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  BookingProvider();

  Future<void> fetchBookings() async {
    _isLoading = true;
    _errorMessage = null;
    try {
      final res = await _apiService
          .get('/bookings');
      _bookings =
          res.map<BookingDTOEXT>((json) => BookingDTOEXT.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBookingsByCustomerId(String customerId) async {
    _isLoading = true;
    _errorMessage = null;
    try {
      final res = await _apiService
          .get('/customers/$customerId/bookings');
      _customerBookings =
          res.map<BookingDTOEXT>((json) => BookingDTOEXT.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBooking(BookingDTOIn booking) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _apiService.post('/bookings', body: booking.toJson());
      await fetchBookings();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBooking(BookingDTO booking) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _apiService.put('/bookings/${booking.id}', body: booking.toJson());
      await fetchBookings();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _apiService.delete('/bookings/$bookingId');
      await fetchBookings();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
