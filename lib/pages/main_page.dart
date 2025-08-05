import 'package:flutter/material.dart';
import 'rent_order_page.dart';
import 'profil_page.dart';
import 'delivery_order_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoading = true;
  int selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.car_rental), label: "Sewa"),
          
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.bar_chart ,
          //   label: "Analitik",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "DO",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: "Pengaturan",
          // ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        return RentOrderDriverPage();
      case 1:
        return  DeliveryOrderPage();
      // case 2:
      //   return DriverAnalyticsPage(doList: doList);
      case 2:
        return ProfilPage();
      default:
        return const Center(child: Text("Halaman tidak ditemukan"));
    }
  }
}