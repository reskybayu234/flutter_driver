import 'package:flutter/material.dart';

Map<String, dynamic> resolveStatusVariant(String? status) {
  final st = status ?? '';

  switch (st) {
    case 'Done':
      return {'color': const Color(0xFF1DE9B6), 'label': 'Terkirim'};
    case 'Assigned':
      return {'color': Colors.amber, 'label': 'Ditugaskan'};
    case 'Weigh In':
      return {'color': const Color(0xFF83C5CC), 'label': 'Timbang Masuk'};
    case 'Weigh Out':
      return {'color': Colors.green, 'label': 'Timbang Keluar'};
    case 'Pending':
      return {'color': Colors.blue, 'label': 'Pending'};
    case 'Close':
      return {'color': Color(0xFF64B5F6), 'label': 'Selesai'};
    default:
      return {'color': Colors.grey, 'label': 'Unknown'};
  }
}
