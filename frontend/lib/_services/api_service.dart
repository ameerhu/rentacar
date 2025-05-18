import 'dart:convert';

import 'package:dio/dio.dart';
import '/auth/basic_auth_interceptor.dart';

import '/commons/error_dto.dart';
import '/commons/exceptions/connection_exception.dart';

class ApiErrorException implements Exception {
  final String message;

  ApiErrorException(this.message);
}

class ApiService {
  final Dio _dio;
  final JsonEncoder _encoder = const JsonEncoder();
  static final ApiService _instance = ApiService.instance();

  factory ApiService() {
    return _instance;
  }

  ApiService.instance() : _dio = Dio() {
    _dio.options.baseUrl = 'http://localhost:8080/api/v1';
    _dio.options.connectTimeout = const Duration(milliseconds: 10000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 3000);

    // Add interceptors if needed (e.g., logging, authentication)
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(BasicAuthInterceptor());
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParams);
      if (response.statusCode != 200) throw ApiErrorException("Not Successful");
      return response.data;
    } on DioException catch (e) {
      final data = Map<String, dynamic>.from(e.response?.data);
      throw Exception(data['message'] ?? "Error while fetching data");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(String url) async {
    return _dio.delete(url).then((Response response) {
      if (response.statusCode! < 200 || response.statusCode! > 400) {
        throw ApiErrorException("Error in deletion of data");
      }
      return response.data;
    }).onError((DioException error, stackTrace) {
      _handleError(error);
    });
  }

  Future<dynamic> post(String url, {body, encoding}) async {
    try {
      final response = await _dio.post(url, data: _encoder.convert(body));
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(String url, {body, encoding}) async {
    try {
      final response = await _dio.put(url, data: _encoder.convert(body));
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      rethrow;
    }
  }

  void _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      // Handleunauthorized error
    } else if (e.type == DioExceptionType.connectionTimeout) {
    } else if (e.type == DioExceptionType.connectionError) {
      throw ConnectionException(
          message:
              e.message != null ? "Network/Server not available." : e.message!);
    } else {
      var errorDTO = ErrorDTO.fromJson(e.response!.data);
      throw errorDTO;
    }
    print('API Error: ${e.message}'); // Log the error
  }
}
