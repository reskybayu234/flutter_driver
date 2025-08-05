import 'package:get/get.dart';

class ProfileController extends GetxController {
  final name = 'John Driver'.obs;
  final email = 'john.driver@example.com'.obs;
  final phone = '+62 812 3456 7890'.obs;
  final status = 'Driver Aktif'.obs;

  void updateProfile({
    String? newName,
    String? newEmail,
    String? newPhone,
    String? newStatus,
  }) {
    if (newName != null) name.value = newName;
    if (newEmail != null) email.value = newEmail;
    if (newPhone != null) phone.value = newPhone;
    if (newStatus != null) status.value = newStatus;
  }
}