import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/driver.dart'; // Assuming you have this model

class DriverService {
  static Future<Driver> getDriverData(String userId) async {
    try {
      final uri = Uri.parse('${ApiConfig.driversEndpoint}/$userId');
      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw HttpException('Connection timeout', statusCode: 408),
          );

      final responseData = _handleResponse(response);
      // print('responseData: $responseData');
      final driver = Driver.fromJson(responseData);

      return driver;
    } on HttpException {
      rethrow;
    } on FormatException catch (e) {
      print('JSON Format Error: $e');
      throw HttpException('Invalid driver data format', statusCode: 500);
    } catch (e) {
      print('Unexpected Error: $e');
      throw HttpException(
        'Failed to fetch driver data: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  static Future<Driver> getDriverById(String driverId) async {
    try {
      final uri = Uri.parse('${ApiConfig.driversEndpoint}/$driverId');
      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw HttpException('Connection timeout', statusCode: 408),
          );

      final responseData = _handleResponse(response);
      
      final driver = Driver.fromJson(responseData);

      return driver;
    } catch (e) {
      print('Unexpected Error: $e');
      throw HttpException(
        'Failed to fetch driver data: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);


    if (response.statusCode != 200) {
      throw HttpException(
        data['message'] ?? 'Failed to fetch driver data',
        statusCode: response.statusCode,
      );
    }

    if (data['data'] == null) {
      throw HttpException(
        'Invalid response format: missing data field',
        statusCode: response.statusCode,
      );
    }

    return data['data'] as Map<String, dynamic>;
  }

  static Future<Driver> updateDriver(Driver driver) async {
    try {
      final uri = Uri.parse('${ApiConfig.driversEndpoint}/${driver.id}');
      final response = await http
          .put(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(driver.toJson()),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw HttpException('Connection timeout', statusCode: 408),
          );

      final responseData = _handleResponse(response);
      return Driver.fromJson(responseData);
    } on HttpException {
      rethrow;
    } on FormatException catch (e) {
      print('JSON Format Error: $e');
      throw HttpException('Invalid driver data format', statusCode: 500);
    } catch (e) {
      print('Unexpected Error: $e');
      throw HttpException(
        'Failed to update driver data: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
  
}

class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, {required this.statusCode});

  @override
  String toString() => 'HttpException: $message (Status Code: $statusCode)';
}
