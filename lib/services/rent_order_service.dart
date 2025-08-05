import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, {required this.statusCode});

  @override
  String toString() => 'HttpException: $message (Status Code: $statusCode)';
}

Future<Map<String, dynamic>> fetchAllRentOrder(String driverId) async {
  try {
    final url = Uri.parse(ApiConfig.rentOrderEndpoint.replaceFirst(':driverId', driverId));
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      if (decodedData is Map<String, dynamic>) {
        return decodedData['data'];
      } else {
        throw HttpException(
          'Invalid response format',
          statusCode: response.statusCode,
        );
      }
    } else {
      throw HttpException(
        'Failed to fetch rent orders',
        statusCode: response.statusCode,
      );
    }
  } catch (e) {
    if (e is HttpException) {
      throw e;
    } else if (e is FormatException) {
      throw HttpException(
        'Invalid JSON format',
        statusCode: 500,
      );
    } else {
      throw HttpException(
        'Network error: ${e.toString()}',
        statusCode: 500,
      );
    }
  }
}