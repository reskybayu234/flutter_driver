import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final _storage = FlutterSecureStorage();

  //Simpan token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  //Ambil token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  //Hapus token
  static Future<void> removeToken() async {
    await _storage.delete(key: 'auth_token');
  }

  //Simpan driver ID
  static Future<void> saveDriverId(String driverId) async {
    await _storage.write(key: 'driver_id', value: driverId);
  }

  //Simpan user ID
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: 'user_id', value: userId);
  }

  //Ambil user ID
  static Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  //Ambil driver ID
  static Future<String?> getDriverId() async {
    return await _storage.read(key: 'driver_id');
  }

  //Hapus driver ID
  static Future<void> removeDriverId() async {
    await _storage.delete(key: 'driver_id');
  }
}