import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'services/auth_service.dart';
import 'pages/main_page.dart';
import 'package:get/get.dart';
import 'controllers/driver_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.put(DriverController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aplikasi Driver DO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: FutureBuilder<bool>(
        // 1. Tentukan tipe explisit
        future: _checkAuthState(),
        builder: (context, snapshot) {
          // 2. Debug lebih detail
          print('''
            Connection: ${snapshot.connectionState}
            HasData: ${snapshot.hasData}
            Data: ${snapshot.data}
            Error: ${snapshot.error}
          ''');

          // 3. Handle semua state dengan benar
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingScreen();
          }

          if (snapshot.hasError) {
            return const LoginPage(); // Fallback ke login jika error
          }

          // 4. Pastikan menggunakan snapshot.hasData
          if (snapshot.data == true) {
            final driverController = Get.find<DriverController>();
            driverController
                .fetchDriverByUserId(); // panggil async tanpa await (karena udah lewat FutureBuilder)
            return const MainPage();
          } else {
            return const LoginPage();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/menu': (context) => const MainPage(),
      },
    );
  }

  Future<bool> _checkAuthState() async {
    try {
      final isValid = await AuthService.validateToken();
      print('Token valid: $isValid');
      return isValid;
    } catch (e) {
      print('Error validating token: $e');
      return false;
    }
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Memeriksa sesi...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
