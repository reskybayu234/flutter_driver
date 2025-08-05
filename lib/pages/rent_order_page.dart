import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/rent_order_service.dart';
import '../utils/status_helper.dart';
import '../services/storage_service.dart';

class RentOrderDriverPage extends StatefulWidget {
  const RentOrderDriverPage({super.key});

  @override
  State<RentOrderDriverPage> createState() => _RentOrderDriverPageState();
}

class _RentOrderDriverPageState extends State<RentOrderDriverPage> {
  
  Map<String, dynamic>? rentOrderList;
  bool isLoading = true;
  int _currentStep = -1;
  bool _isRefreshing = false;

  @override 
  void initState() {
    super.initState();
    loadRentOrder();
  }
  
  Future<void> loadRentOrder() async {
    try {
      final driverId = await StorageService.getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID not found');
      }

      final result = await fetchAllRentOrder(driverId);
      if (!mounted) return;
      setState(() {
        rentOrderList = result;
        if (rentOrderList != null) {
          if(rentOrderList!['status'] == 'Pending') {
            _currentStep = 0;
          } else if (rentOrderList!['status'] == 'Progress') {
            _currentStep = 1;
          }
          else if (rentOrderList!['status'] == 'Closed') {
            _currentStep = 3;
          } 
          isLoading = false;
        } else if (rentOrderList == null) {
          _currentStep = -1;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        rentOrderList = null;
        isLoading = false;
      });
    }
  }

  Future<void> _refreshRentOrder() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await loadRentOrder();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil diperbarui'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui data: ${e.toString()}'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
    
  }

  String _getStatusText(int step) {
    switch (step) {
      case 0:
        return 'Mobil di Assign';
      case 1:
        return 'Dalam proses...';
      case 3:
        return 'Rent Order Selesai';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? const Center(child: CircularProgressIndicator()) : _buildRentOrderList(),
    );
  }

  Widget _buildRentOrderList() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.blue,
          height: 200,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sewa Kendaraan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          key: ValueKey(_currentStep),
                          _getStatusText(_currentStep),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isRefreshing
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 28,
                          ),
                  ),
                  onPressed: _refreshRentOrder,
                  tooltip: 'Perbarui Data',
                  splashRadius: 28,
                  splashColor: Colors.white24,
                  highlightColor: Colors.white10,
                ),
              ),
            ],
          ),
        ),
        
        // Card(
        //   margin: const EdgeInsets.only(
        //     left: 70,   // Left margin
        //     right: 70,  // Right margin
        //     top: 16,   // Uncomment if you need top margin
        //     // bottom: 8 // Uncomment if you need bottom margin
        //   ),
        //   elevation: 2,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Container(
        //     padding: const EdgeInsets.all(16),
        //     child: Column(
        //       children: [
        //         // Step Circles with Connectors
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: List.generate(
        //             3,
        //             (index) => GestureDetector(
        //               child: Row(
        //                 children: [
        //                   if (index > 0)
        //                     Container(
        //                       width: 20,
        //                       height: 2,
        //                       color: _currentStep > index
        //                           ? const Color(0xFF00E457)
        //                           : _currentStep == index
        //                               ? const Color(0xFFFF961D)
        //                               : Colors.grey[300],
        //                     ),
        //                   Container(
        //                     width: 30,
        //                     height: 30,
        //                     decoration: BoxDecoration(
        //                       shape: BoxShape.circle,
        //                       color: _currentStep > index
        //                           ? const Color(0xFF00E457)
        //                           : _currentStep == index
        //                               ? const Color(0xFFFF961D)
        //                               : Colors.grey[300],
        //                       border: Border.all(
        //                         color: _currentStep > index
        //                             ? const Color(0xFF00E457)
        //                             : _currentStep == index
        //                                 ? const Color(0xFFFF961D)
        //                                 : Colors.grey[400]!,
        //                       ),
        //                     ),
        //                     child: Center(
        //                       child: _currentStep > index
        //                           ? const Icon(
        //                               Icons.check,
        //                               color: Colors.white,
        //                               size: 20,
        //                             )
        //                           : Text(
        //                               '${index + 1}',
        //                               style: TextStyle(
        //                                 color: _currentStep == index
        //                                     ? Colors.white
        //                                     : Colors.grey[600],
        //                                 fontWeight: FontWeight.bold,
        //                               ),
        //                             ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),  
        //       ],
        //     ),
        //   ),
        // ),

        Column(
          children: [
            if(rentOrderList == null || rentOrderList!.isEmpty)
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container (
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Tidak ada Rent Order',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                    ),
                  )
                )
              )
            else 
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: 500,
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (rentOrderList!['orderNumber'] != null &&
                          rentOrderList!['orderNumber'] != '')
                        Text(
                          'No. Surat Jalan: ${rentOrderList!['orderNumber']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        const Text(
                          'No. Rent Order: -',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 8),
                      
                      if (rentOrderList!['driver'] != null)
                        Text(
                          'Driver: ${rentOrderList!['driver']['name']}',
                          style: const TextStyle(fontSize: 14),
                        ),

                      const SizedBox(height: 8),
                      
                      if (rentOrderList!['vehicle'] != null)
                        Text(
                          'Kendaraan: ${rentOrderList!['vehicle']['licensePlate']}',
                          style: const TextStyle(fontSize: 14),
                        ),

                      const SizedBox(height: 8),

                      const Text(
                        'Tujuan: Tongkang Cirebon',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        )
      ]
    );
  }
  
}