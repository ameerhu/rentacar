import 'package:flutter/material.dart';

import '/_services/api_service.dart';
import '/domains/booking_dto.dart';
import '/domains/inbound/booking_dto_in.dart';

class BookingProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<BookingDTO> _bookings = [];

  List<BookingDTO> get bookings => _bookings;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  BookingProvider();

  Future<void> fetchBookings() async {
    _isLoading = true;
    _errorMessage = null;
    // notifyListeners();
    try {
      final res = await _apiService
          .get('/customers/9e8fd484-d0e5-44e5-830a-769732f6653a/bookings');
      _bookings =
          res.map<BookingDTO>((json) => BookingDTO.fromJson(json)).toList();
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

  Future<void> updateBooking(BookingDTOIn booking) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _apiService.put('/bookings', body: booking.toJson());
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
