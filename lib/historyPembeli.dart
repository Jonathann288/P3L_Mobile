// File: lib/historyPembeli.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/client/transaksi_client.dart';
import 'package:flutter_application_reusemart/entity/transaksipenjualan.dart';
import 'package:intl/intl.dart';

// ... (kode StatefulWidget dan State class tetap sama)
class HistoryPembeli extends StatefulWidget {
  const HistoryPembeli({super.key});

  @override
  State<HistoryPembeli> createState() => _HistoryPembeliState();
}

class _HistoryPembeliState extends State<HistoryPembeli> {
  // ... (semua fungsi seperti initState, _selectDate, _fetchHistory tidak berubah)
  DateTime? _startDate;
  DateTime? _endDate;
  List<TransaksiPenjualan> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = DateTime.now().subtract(const Duration(days: 30));
    _fetchHistory();
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _fetchHistory() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Periode tanggal tidak valid')),
      );
      return;
    }
    setState(() { _isLoading = true; _errorMessage = null; });
    try {
      final formattedStartDate = DateFormat('yyyy-MM-dd').format(_startDate!);
      final formattedEndDate = DateFormat('yyyy-MM-dd').format(_endDate!);
      final transactions = await TransaksiClient.fetchHistory(formattedStartDate, formattedEndDate);
      setState(() { _transactions = transactions; });
    } catch (e) {
      setState(() { _errorMessage = e.toString(); });
    } finally {
      if (mounted) { setState(() { _isLoading = false; }); }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (kode build utama tidak berubah)
     return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectDate(context, isStartDate: true),
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(_startDate == null ? 'Mulai' : DateFormat('dd/MM/yy').format(_startDate!)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('-'),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _selectDate(context, isStartDate: false),
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(_endDate == null ? 'Selesai' : DateFormat('dd/MM/yy').format(_endDate!)),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  onPressed: _fetchHistory,
                  icon: const Icon(Icons.search),
                  style: IconButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Text('Terjadi kesalahan:\n$_errorMessage', textAlign: TextAlign.center)))
                    : _transactions.isEmpty
                        ? const Center(child: Text('Tidak ada riwayat transaksi ditemukan.'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: _transactions.length,
                            itemBuilder: (context, index) {
                              final trx = _transactions[index];
                              return _buildTransactionCard(trx);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  // ==================== FOKUS PERBAIKAN DI SINI ====================
  Widget _buildTransactionCard(TransaksiPenjualan trx) {
    double totalProduk = trx.detailTransaksi.fold(0, (sum, item) => sum + (item.harga * item.jumlah));
    double grandTotal = totalProduk + trx.ongkir;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text('Nota: ${trx.noNota}', style: const TextStyle(fontWeight: FontWeight.bold)),
         subtitle: Text('Tanggal: ${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(DateTime.parse(trx.tanggalTransaksi))}'),
        children: [
          ...trx.detailTransaksi.map((detail) {
            // Kita sudah tahu dari debug bahwa detail.barang tidak null
            final barang = detail.barang!;
            
            final imageUrl = barang.firstImage != null 
              ? "http://192.168.1.6/P3L/public/${barang.firstImage}" 
              : null;
            
            // Kita sudah tahu dari debug bahwa harga barang tidak null
            final hargaSatuan = barang.hargaBarang;

            return ListTile(
              // 1. TAMPILKAN GAMBAR
              leading: SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          // Error builder ini akan tampil jika URL tidak bisa diakses
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.grey),
                        )
                      : const Icon(Icons.shopping_bag, color: Colors.grey), // Tampil jika tidak ada gambar
                ),
              ),
              title: Text(barang.nama),
              // 2. TAMPILKAN HARGA DENGAN LEBIH JELAS
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Harga Satuan: Rp ${NumberFormat.decimalPattern('id_ID').format(hargaSatuan)}"),
                  Text("Jumlah: ${detail.jumlah} buah"),
                ],
              ),
              trailing: Text(
                'Rp ${NumberFormat.decimalPattern('id_ID').format(detail.jumlah * hargaSatuan)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              isThreeLine: true,
            );
          }).toList(),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Divider(height: 1),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                _buildSummaryRow(Icons.receipt_long, 'Subtotal Produk', 'Rp ${NumberFormat.decimalPattern('id_ID').format(totalProduk)}'),
                _buildSummaryRow(Icons.local_shipping, 'Ongkos Kirim', 'Rp ${NumberFormat.decimalPattern('id_ID').format(trx.ongkir)}'),
                _buildSummaryRow(Icons.payment, 'Grand Total', 'Rp ${NumberFormat.decimalPattern('id_ID').format(grandTotal)}', isBold: true),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatusChip("Metode: ${trx.metodePengantaran}"),
                    _buildStatusChip(trx.statusPembayaran, isPayment: true),
                    _buildStatusChip(trx.statusTransaksi),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String title, String value, {bool isBold = false}) {
    // ... (tidak berubah)
     return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          const Spacer(),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
  
  Widget _buildStatusChip(String status, {bool isPayment = false}) {
    // ... (tidak berubah)
    Color chipColor = Colors.grey;
    String statusText = status.toLowerCase();
    if (isPayment) {
      if (statusText == 'lunas') chipColor = Colors.green;
      else if (statusText == 'belum lunas') chipColor = Colors.orange;
    } else {
      if (statusText.contains('selesai')) chipColor = Colors.green;
      else if (statusText.contains('dikirim')) chipColor = Colors.blue;
      else if (statusText.contains('diproses')) chipColor = Colors.orange;
      else if (statusText.contains('batal')) chipColor = Colors.red;
    }
    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}