// File: lib/historyPembeli.dart (Dengan Kalender Bottom Sheet)
import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/client/transaksi_client.dart';
import 'package:flutter_application_reusemart/entity/transaksipenjualan.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// ENUM untuk mempermudah pengelolaan filter cepat
enum DateFilterOptions { last7Days, last30Days, custom }

class HistoryPembeli extends StatefulWidget {
  const HistoryPembeli({super.key});

  @override
  State<HistoryPembeli> createState() => _HistoryPembeliState();
}

class _HistoryPembeliState extends State<HistoryPembeli> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  List<TransaksiPenjualan> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;
  DateFilterOptions _activeFilter = DateFilterOptions.last30Days;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _CalendarRangePickerSheet(
          initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _activeFilter = DateFilterOptions.custom;
        _fetchHistory();
      });
    }
  }

  void _onFilterChanged(DateFilterOptions filter) {
    setState(() {
      _activeFilter = filter;
      if (filter == DateFilterOptions.last7Days) {
        _startDate = DateTime.now().subtract(const Duration(days: 7));
        _endDate = DateTime.now();
      } else if (filter == DateFilterOptions.last30Days) {
        _startDate = DateTime.now().subtract(const Duration(days: 30));
        _endDate = DateTime.now();
      }
      _fetchHistory();
    });
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final formattedStartDate = DateFormat('yyyy-MM-dd').format(_startDate);
      final formattedEndDate = DateFormat('yyyy-MM-dd').format(_endDate);
      final transactions = await TransaksiClient.fetchHistory(
          formattedStartDate, formattedEndDate);
      setState(() {
        _transactions = transactions;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Terjadi kesalahan:\n$_errorMessage',
                                textAlign: TextAlign.center)))
                    : _transactions.isEmpty
                        ? const Center(
                            child:
                                Text('Tidak ada riwayat transaksi ditemukan.'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
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

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Filter Tanggal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildFilterChip("7 Hari Terakhir", DateFilterOptions.last7Days),
              const SizedBox(width: 8),
              _buildFilterChip(
                  "30 Hari Terakhir", DateFilterOptions.last30Days),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _selectCustomDateRange(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.blue, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        "${DateFormat('d MMM yy', 'id_ID').format(_startDate)} - ${DateFormat('d MMM yy', 'id_ID').format(_endDate)}",
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, DateFilterOptions filter) {
    final bool isSelected = _activeFilter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _onFilterChanged(filter);
        }
      },
      selectedColor: Colors.blue.withOpacity(0.2),
      checkmarkColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildTransactionCard(TransaksiPenjualan trx) {
    double totalProduk = trx.detailTransaksi.fold(0, (sum, item) {
      final hargaSatuan = item.barang?.hargaBarang ?? 0.0;
      return sum + (hargaSatuan * 1);
    });
    double grandTotal = totalProduk + trx.ongkir;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        backgroundColor: Colors.white,
        collapsedBackgroundColor: Colors.white,
        title: Text('No Transaksi: ${trx.noNota}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        // [PERUBAHAN] Menggunakan Column untuk subtitle agar bisa menampilkan 2 baris tanggal
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4), // Memberi sedikit jarak dari title
            Text(
                'Tanggal: ${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(DateTime.parse(trx.tanggalTransaksi))}'),
            const SizedBox(height: 2),
            // [TAMBAHAN] Menampilkan Tanggal Selesai (Lunas) jika ada
            if (trx.tanggalLunas != null)
              Text(
                'Selesai: ${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(DateTime.parse(trx.tanggalLunas!))}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
          ],
        ),
        children: [
          const Divider(height: 1),
          ...trx.detailTransaksi.map((detail) {
            final barang = detail.barang!;
            final imageUrl = barang.firstImage != null
                ? "http://172.20.10.5/P3L/public/${barang.firstImage}"
                : null;
            final hargaSatuan = barang.hargaBarang;
            final totalPerItem = 1 * hargaSatuan;

            return ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl != null
                      ? Image.network(imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported,
                                  color: Colors.grey))
                      : const Icon(Icons.shopping_bag, color: Colors.grey),
                ),
              ),
              title: Text(barang.nama),
              subtitle: Text(
                  "Rp ${NumberFormat.decimalPattern('id_ID').format(hargaSatuan)} x 1"),
              trailing: Text(
                  'Rp ${NumberFormat.decimalPattern('id_ID').format(totalPerItem)}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 8),
                _buildSummaryRow('Subtotal Produk',
                    'Rp ${NumberFormat.decimalPattern('id_ID').format(totalProduk)}'),
                _buildSummaryRow('Ongkos Kirim',
                    'Rp ${NumberFormat.decimalPattern('id_ID').format(trx.ongkir)}'),
                _buildSummaryRow('Grand Total',
                    'Rp ${NumberFormat.decimalPattern('id_ID').format(grandTotal)}',
                    isBold: true),
                _buildSummaryRow('Poin Diperoleh',
                    '+${trx.poinDapat} Poin', // Akses poin dari objek "trx"
                    icon: Icons.star_border_purple500_outlined),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildStatusChip(trx.statusPembayaran, isPayment: true),
                    const SizedBox(width: 8),
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

  Widget _buildSummaryRow(String title, String value,
      {bool isBold = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null)
                Icon(icon, size: 18, color: Colors.amber.shade700),
              if (icon != null) const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      fontSize: isBold ? 15 : 14)),
            ],
          ),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: isBold ? 15 : 14,
                  color: icon != null ? Colors.amber.shade900 : null)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, {bool isPayment = false}) {
    Color chipColor = Colors.grey;
    String statusText = status.toLowerCase();
    if (isPayment) {
      if (statusText == 'lunas') chipColor = Colors.green;
      if (statusText == 'belum lunas') chipColor = Colors.orange;
    } else {
      if (statusText.contains('selesai')) chipColor = Colors.green;
      if (statusText.contains('dikirim')) chipColor = Colors.blue;
      if (statusText.contains('diproses')) chipColor = Colors.orange;
      if (statusText.contains('batal')) chipColor = Colors.red;
    }
    return Chip(
      label: Text(status,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _CalendarRangePickerSheet extends StatefulWidget {
  final DateTimeRange initialDateRange;

  const _CalendarRangePickerSheet({required this.initialDateRange});

  @override
  State<_CalendarRangePickerSheet> createState() =>
      _CalendarRangePickerSheetState();
}

class _CalendarRangePickerSheetState extends State<_CalendarRangePickerSheet> {
  late DateTime _focusedDay;
  late DateTime? _rangeStart;
  late DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDateRange.start;
    _rangeStart = widget.initialDateRange.start;
    _rangeEnd = widget.initialDateRange.end;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pilih Rentang Tanggal',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TableCalendar(
            locale: 'id_ID',
            firstDay: DateTime(2020),
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            rangeSelectionMode:
                RangeSelectionMode.toggledOn, 
            onDaySelected: (selectedDay, focusedDay) {
              // Dibiarkan kosong karena kita fokus pada onRangeSelected
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _rangeStart = start;
                _rangeEnd = end;
                _focusedDay = focusedDay;
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible:
                  false, 
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              rangeHighlightColor: Colors.blue.withOpacity(0.2),
              rangeStartDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup sheet tanpa mengirim data
                  },
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_rangeStart != null) {
                      Navigator.pop(
                          context,
                          DateTimeRange(
                            start: _rangeStart!,
                            end: _rangeEnd ?? _rangeStart!,
                          ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Pilih'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
