import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'storage_service.dart';
import '../services/driver_service.dart' show DriverService;
import '../models/driver.dart';
import '../utils/http_exception.dart' show HttpException;

/// Decode JWT token dan return payload sebagai Map
Map<String, dynamic> _decodeToken(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw FormatException('Invalid token format');
  }

  final payload = parts[1];
  final normalized = base64Url.normalize(payload);
  final resp = utf8.decode(base64Url.decode(normalized));
  return json.decode(resp);
}

class AuthService {

  static Future<void> logout() async {
    await StorageService.removeToken();
    await StorageService.removeDriverId();
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try { 

      final response = await http.post(
        Uri.parse('${ApiConfig.authEndpoint}/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw HttpException('Connection timeout', statusCode: 408),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'] as String;
        await StorageService.saveToken(token);
        
        // Decode token untuk mendapatkan userId

        // print(token);
        final tokenPayload = _decodeToken(token);
        // print(tokenPayload);
        final userId = tokenPayload['id'] as String;
        print('userId $userId');

        // Get driver data using userId from token
        final Driver driverData = await DriverService.getDriverData(userId);


        print('driverData $driverData');
        await StorageService.saveDriverId(driverData.id);
        await StorageService.saveUserId(userId);
        
        return data;
      } else {
        throw HttpException(
          data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> validateToken() async {
    final token = await StorageService.getToken();
    if (token == null) return false;
    // print("==========================");
    // print("token : $token");
    // print("==========================");
    // Contoh validasi token ke backend (sesuaikan dengan API Anda)

    return true;
    // try {
    //   final response = await http.get(
    //     Uri.parse('$_baseUrl/validate'),
    //     headers: {'Authorization': 'Bearer $token'},
    //   );
    //   return response.statusCode == 200;
    // } catch (e) {
    //   return false;
    // }
  }
}