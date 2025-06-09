// lib/historyPenitip.dart

import 'package:flutter/material.dart';
// Import diubah ke client yang baru
import 'package:flutter_application_reusemart/client/transaksipenitipan_client.dart'; 
// Import diubah ke model yang baru
import 'package:flutter_application_reusemart/entity/transaksipenitipan.dart'; 

class HistoryPenitipPage extends StatefulWidget {
  const HistoryPenitipPage({super.key});

  @override
  State<HistoryPenitipPage> createState() => _HistoryPenitipPageState();
}

class _HistoryPenitipPageState extends State<HistoryPenitipPage> {
  bool _isLoading = true;
  String? _errorMessage;
  // Tipe list diubah menjadi TransaksiPenitipanHistory
  List<TransaksiPenitipanHistory> _historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      // Pemanggilan method diubah ke client yang baru
      final history = await TransaksiPenitipanClient.fetchHistory();
      setState(() {
        _historyList = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // ... (Sisa kode di dalam _HistoryPenitipPageState tidak perlu diubah, 
  //      karena nama properti di dalam class TransaksiPenitipanHistory tetap sama)

  Widget _buildStatusChip(String? status) {
    Color chipColor;
    String chipLabel = status ?? 'Tidak Diketahui';

    switch (status?.toLowerCase()) {
      case 'laku':
        chipColor = Colors.green;
        chipLabel = 'Terjual';
        break;
      case 'tidak laku':
        chipColor = Colors.orange;
        chipLabel = 'Belum Terjual';
        break;
      case 'donasikan':
      case 'di donasikan':
        chipColor = Colors.blue;
        chipLabel = 'Didonasikan';
        break;
      case 'sudah diambil':
        chipColor = Colors.grey;
        chipLabel = 'Diambil Kembali';
        break;
      default:
        chipColor = Colors.black45;
    }

    return Chip(
      label: Text(chipLabel, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Barang Titipan'),
        backgroundColor: const Color(0xFF33AADD),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error: $_errorMessage'),
        ),
      );
    }

    if (_historyList.isEmpty) {
      return const Center(
        child: Text(
          'Anda belum pernah menitipkan barang.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _historyList.length,
      itemBuilder: (context, index) {
        final item = _historyList[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: item.fotoBarang != null
                      ? Image.network(
                          'http://192.168.1.13/P3L/public/${item.fotoBarang}', // Sesuaikan IP & path
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                        )
                      : const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.namaBarang,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dititipkan: ${item.tanggalPenitipan}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                       Text(
                        'Batas Waktu: ${item.tanggalAkhirPenitipan}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildStatusChip(item.statusBarang),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}