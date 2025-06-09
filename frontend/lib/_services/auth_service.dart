import 'package:dio/dio.dart';
import '/auth/rac_storage.dart';
import '/domains/customer_dto.dart';

import '/_services/api_service.dart';
import '/domains/inbound/login_dto_in.dart';
import '/domains/inbound/register_dto_in.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  static final AuthService _instance = AuthService.instance();

  factory AuthService() {
    return _instance;
  }

  AuthService.instance();

  Future<dynamic> login(LoginDtoIn loginDTOIn) async {
    return await _apiService.post('/auth/login', body: loginDTOIn);
    try {
      final response = await _apiService.post('/auth/login', body: loginDTOIn);
      return response;
    } catch (e) {
      // throw Exception('Failed to login');
      print('Error during login: $e');
      rethrow;
    }
  }

  Future<Response> register(RegisterDtoIn registerDTOIn) async {
    return await _apiService.post('/auth/register', body: registerDTOIn);
    /*
    try {
    } catch (e) {
      throw RegistrationException(message: 'Failed to register',);
    }
    */
  }

  Future<bool> isTokenValid() async {
    await Future.delayed(const Duration(seconds: 3));
    String? token = await RACStorage.getToken();
    if (token == null) return false;
    try{
      final json = await _apiService.get("/users/currentUser");
      CustomerDTO user = CustomerDTO.fromJson(json);
      if (user.cnic.isNotEmpty) return false;
    }catch(e) {
      RACStorage.deleteToken();
      return false;
    }
    return true;
  }
}
