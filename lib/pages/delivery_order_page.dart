import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/do_service.dart';
import '../utils/status_helper.dart';
import '../services/storage_service.dart';

class DeliveryOrderPage extends StatefulWidget {
  const DeliveryOrderPage({super.key});

  @override
  State<DeliveryOrderPage> createState() => _DeliveryOrderPageState();
}

class _DeliveryOrderPageState extends State<DeliveryOrderPage> {
  bool isLoading = true;
  bool _isRefreshing = false;
  int _currentStep = -1;
  Map<String, dynamic>? deliveryOrderList;

  @override
  void initState() {
    super.initState();
    loadDeliveryOrder();
  }

  Future<void> loadDeliveryOrder() async {
    try {
      final driverId = await StorageService.getDriverId();
      if (driverId == null) {
        throw Exception('Driver ID not found');
      }

      final result = await fetchDObyDriverId(driverId);

      if (!mounted) return;

      setState(() {
        deliveryOrderList = result;
        if (deliveryOrderList != null) {
          if (deliveryOrderList != null &&
              deliveryOrderList!['listVehicle'] != null &&
              (deliveryOrderList!['listVehicle'] as List).isNotEmpty) {
            final firstVehicle = (deliveryOrderList!['listVehicle'] as List)[0];

            if (firstVehicle['status'] == 'Assigned') {
              setState(() {
                _currentStep = 0;
              });
            } else if (firstVehicle['status'] == 'Weight In') {
              setState(() {
                _currentStep = 1;
              });
            } else if (firstVehicle['status'] == 'Weight Out') {
              setState(() {
                _currentStep = 3;
              });
            }
          }
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        deliveryOrderList = null;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _refreshShippingDoc() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      await loadDeliveryOrder();
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
        return 'Assigned';
      case 1:
        return 'Weigh In';
      case 2:
        return 'Proses Weigh In';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildDeliveryOrder(),
    );
  }

  Widget _buildDeliveryOrder() {
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
                        'Proses Delivery Order',
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
                  onPressed: _refreshShippingDoc,
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
        //   margin: const EdgeInsets.all(16),
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
        //                           ? const Color(0xFFFF961D)
        //                           : Colors.grey[300],
        //                     ),
        //                   Container(
        //                     width: 30,
        //                     height: 30,
        //                     decoration: BoxDecoration(
        //                       shape: BoxShape.circle,
        //                       color: _currentStep > index
        //                           ? const Color(0xFF00E457)
        //                           : _currentStep == index
        //                           ? const Color(0xFFFF961D)
        //                           : Colors.grey[300],
        //                       border: Border.all(
        //                         color: _currentStep > index
        //                             ? const Color(0xFF00E457)
        //                             : _currentStep == index
        //                             ? const Color(0xFFFF961D)
        //                             : Colors.grey[400]!,
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
            if (deliveryOrderList == null || deliveryOrderList!.isEmpty)
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Belum ada Surat Jalan yang di-assign ke Anda',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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
                      if (deliveryOrderList!['deliveryNumber'] != null &&
                          deliveryOrderList!['deliveryNumber'] != '')
                        Text(
                          'No. DO: ${deliveryOrderList!['deliveryNumber']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        const Text(
                          'No. Delivery Order: -',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 8),

                      if (deliveryOrderList != null &&
                          deliveryOrderList!['listVehicle'] != null &&
                          (deliveryOrderList!['listVehicle'] as List)
                              .isNotEmpty)
                        Text(
                          'Driver: ${(deliveryOrderList!['listVehicle'] as List)[0]!['driver']['name']}',
                          style: const TextStyle(fontSize: 14),
                        ),

                      const SizedBox(height: 8),

                      if (deliveryOrderList != null &&
                          deliveryOrderList!['listVehicle'] != null &&
                          (deliveryOrderList!['listVehicle'] as List)
                              .isNotEmpty)
                        Text(
                          'Kendaraan: ${(deliveryOrderList!['listVehicle'] as List)[0]!['vehicle']['licensePlate']}',
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
        ),
      ],
    );
  }
}
