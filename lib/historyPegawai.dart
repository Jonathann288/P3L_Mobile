// lib/views/historyPegawai/history_pegawai_page.dart
import 'package:flutter/material.dart';

class HistoryPegawaiPage extends StatelessWidget {
  const HistoryPegawaiPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy history pengiriman
    final List<Map<String, dynamic>> deliveryHistory = [
      {
        'buyerName': 'Budi Santoso',
        'itemName': 'Kaos ReuseMart',
        'itemPrice': 50000,
        'deliveryDate': '15 Mei 2023',
        'status': 'Terkirim',
        'shippingCost': 15000,
        'totalPrice': 65000,
      },
      {
        'buyerName': 'Ani Wijaya',
        'itemName': 'Botol Bekas',
        'itemPrice': 15000,
        'deliveryDate': '16 Mei 2023',
        'status': 'Dalam Pengiriman',
        'shippingCost': 12000,
        'totalPrice': 27000,
      },
      {
        'buyerName': 'Rudi Hermawan',
        'itemName': 'Tas Rajut',
        'itemPrice': 75000,
        'deliveryDate': '17 Mei 2023',
        'status': 'Gagal',
        'shippingCost': 20000,
        'totalPrice': 95000,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('History Pengiriman'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Tugas Pengiriman Anda',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...deliveryHistory.map((delivery) {
            final statusColor = _getStatusColor(delivery['status']);

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            delivery['buyerName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: statusColor),
                          ),
                          child: Text(
                            delivery['status'],
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Barang: ${delivery['itemName']}'),
                    const SizedBox(height: 8),
                    Text('Tanggal Kirim: ${delivery['deliveryDate']}'),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Harga Barang'),
                            Text('Rp ${delivery['itemPrice']}'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Ongkos Kirim'),
                            Text('Rp ${delivery['shippingCost']}'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Total'),
                            Text(
                              'Rp ${delivery['totalPrice']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Terkirim':
        return Colors.green;
      case 'Dalam Pengiriman':
        return Colors.orange;
      case 'Gagal':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
