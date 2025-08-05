import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/http_exception.dart' show HttpException;

Future<List<dynamic>> fetchDOs() async {
  try {
    final url = Uri.parse(ApiConfig.doStockpileEndpoint);
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw HttpException('Connection timeout', statusCode: 408),
    );

    final body = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      if (body['data'] == null) {
        throw HttpException('Invalid response format: missing data field', statusCode: response.statusCode);
      }
      return body['data'] as List<dynamic>;
    } else {
      throw HttpException(
        body['message'] ?? 'Failed to fetch DO data',
        statusCode: response.statusCode,
      );
    }
  } on FormatException catch (e) {
    throw HttpException('Invalid server response format', statusCode: 500);
  } on http.ClientException catch (e) {
    throw HttpException('Network connection failed', statusCode: 503);
  } catch (e) {
    throw HttpException('An unexpected error occurred', statusCode: 500);
  }
}


Future<Map<String, dynamic>> fetchDObyDriverId(String driverId) async {
  try {
    final url = Uri.parse(ApiConfig.doStockpileMobileEndpoint.replaceFirst(':driverId', driverId));
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw HttpException('Connection timeout', statusCode: 408),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (body['data'] == null) {
        throw HttpException('Invalid response format: missing data field', statusCode: response.statusCode);
      }
      return body['data'] as Map<String, dynamic>;
    } else {
      throw HttpException(
        body['message'] ?? 'Failed to fetch DO data',
        statusCode: response.statusCode,
      );
    }
  } catch (e) {
    throw HttpException('An unexpected error occurred', statusCode: 500);
  }
}