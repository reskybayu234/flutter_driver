import 'package:get/get.dart';
import '../services/driver_service.dart';
import '../models/driver.dart';
import '../services/storage_service.dart';

class DriverController extends GetxController {
  final Rx<Driver?> driver = Rx<Driver?>(null);

  Future<void> getDriverData(String userId) async {
    try {
      final driverData = await DriverService.getDriverData(userId);
      driver.value = driverData;
    } catch (e) {
      print('Error fetching driver data: $e');
    }
  }

  Future<void> fetchDriverByUserId () async {
    try {
      final userId = await StorageService.getUserId();
      if (userId == null) {
        throw Exception('Driver ID not found');
      }
      final driverData = await DriverService.getDriverData(userId);
      driver.value = driverData;
    } catch (e) {
      print('Error fetching driver data: $e');
    }
  }


  Future<void> updateDriverData({
    String? newName,
    String? driverID,
    String? email,
    String? phone,
    String? status,
  }) async {
    try {
      if (driver.value == null) return;
      
      final updatedDriver = Driver(
        id: driver.value!.id,
        name: newName ?? driver.value!.name,
        driverID: driverID ?? driver.value!.driverID,
        status: status ?? driver.value!.status,
      );
      
      await DriverService.updateDriver(updatedDriver);
      driver.value = updatedDriver;
    } catch (e) {
      print('Error updating driver data: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // fetchDriverByUserId();
  }
}
