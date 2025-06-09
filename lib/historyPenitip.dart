import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_reusemart/client/transaksipenitipan_client.dart';
import 'package:flutter_application_reusemart/entity/transaksipenitipan.dart';

class HistoryPenitipPage extends StatefulWidget {
  const HistoryPenitipPage({super.key});

  @override
  State<HistoryPenitipPage> createState() => _HistoryPenitipPageState();
}

class _HistoryPenitipPageState extends State<HistoryPenitipPage> {
  bool _isLoading = true;
  String? _errorMessage;
  List<TransaksiPenitipanHistory> _historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    // Simulasi loading agar efeknya terlihat
    // await Future.delayed(const Duration(seconds: 2)); 
    try {
      final history = await TransaksiPenitipanClient.fetchHistory();
      if (!mounted) return;
      setState(() {
        _historyList = history;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll("Exception: ", "");
        _isLoading = false;
      });
    }
  }

  // =======================================================================
  // PERUBAHAN TOTAL: Menggunakan showModalBottomSheet untuk tampilan modern
  // =======================================================================
  void _showDetailModal(BuildContext context, TransaksiPenitipanHistory item) {
    final String hargaFormatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(item.hargaBarang ?? 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Penting agar sheet bisa full height
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8, // Muncul 80% dari layar
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Gagang (handle)
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Konten yang bisa di-scroll
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        // Gambar Produk
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: item.fotoBarang != null
                                ? Image.network(
                                    'http://192.168.1.13/P3L/public/${item.fotoBarang}',
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    height: MediaQuery.of(context).size.width * 0.6,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image, size: 120, color: Colors.grey),
                                  )
                                : const Icon(Icons.inventory_2_outlined, size: 120, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Nama Barang dan Harga
                        Text(
                          item.namaBarang,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hargaFormatted,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepOrange[400],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(thickness: 1, indent: 20, endIndent: 20),
                        const SizedBox(height: 16),
                        
                        // Detail-detail
                        _buildDetailRow(Icons.vpn_key_outlined, "ID Transaksi Penitipan", item.idTransaksiPenitipan ?? '-'),
                        _buildDetailRow(Icons.calendar_today_outlined, "Tanggal Penitipan", item.tanggalPenitipan),
                        _buildDetailRow(Icons.event_busy_outlined, "Batas Pengambilan", item.tanggalBatasPengambilan ?? 'Belum ditentukan'),
                        _buildDetailRow(Icons.info_outline, "Status", _getStatusLabel(item.statusBarang)),

                        const SizedBox(height: 30),
                        // Tombol Tutup dengan Gradasi
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: _buildGradientButton(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper untuk Tombol Gradasi
  Widget _buildGradientButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF33AADD), Color(0xFF1F8BC4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(15),
          child: const SizedBox(
            height: 50,
            child: Center(
              child: Text(
                "Tutup",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper untuk baris detail (desain diperbarui)
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 20),
          Expanded(child: Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[700]))),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // Helper untuk mendapatkan label status (tidak ada perubahan)
  String _getStatusLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'laku': return 'Terjual';
      case 'tidak laku': return 'Belum Terjual';
      case 'donasikan':
      case 'di donasikan': return 'Didonasikan';
      case 'sudah diambil': return 'Diambil Kembali';
      default: return status ?? 'Tidak Diketahui';
    }
  }

  // WIDGET UNTUK STATUS DENGAN CHIP (desain diperbarui)
  Widget _buildStatusChip(String? status) {
    Color chipColor;
    String chipLabel = _getStatusLabel(status);

    switch (status?.toLowerCase()) {
      case 'laku': chipColor = Colors.green; break;
      case 'tidak laku': chipColor = const Color.fromARGB(255, 245, 187, 7); break;
      case 'donasikan': case 'di donasikan': chipColor = Colors.blue; break;
      case 'sudah diambil': chipColor = Colors.grey; break;
      default: chipColor = Colors.black45;
    }

    return Chip(
      label: Text(chipLabel, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // PERUBAHAN VISUAL: Latar belakang halaman
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        // PERUBAHAN VISUAL: AppBar dengan gradasi
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF33AADD), Color(0xFF1F8BC4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Riwayat Barang Titipan', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
      body: _buildBody(),
    );
  }

Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text('Error: $_errorMessage'));
    }
    if (_historyList.isEmpty) {
      return const Center(child: Text('Anda belum pernah menitipkan barang.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _historyList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _historyList[index];
        return InkWell(
          onTap: () => _showDetailModal(context, item),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Agar alignment rapi
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: item.fotoBarang != null
                      ? NetworkImage('http://192.168.1.13/P3L/public/${item.fotoBarang}')
                      : null,
                  child: item.fotoBarang == null 
                      ? const Icon(Icons.inventory_2_outlined, size: 30, color: Colors.grey) 
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Semua item rata kiri
                    children: [
                      Text(
                        item.namaBarang,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text('Tanggal Penitipan: ${item.tanggalPenitipan}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.event_busy, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text('Tanggal Akhir Penitipan: ${item.tanggalAkhirPenitipan}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Memberi jarak ke status
                      
                      // =======================================================
                      // PERUBAHAN: Status Chip dipindahkan ke sini
                      // =======================================================
                      _buildStatusChip(item.statusBarang),
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