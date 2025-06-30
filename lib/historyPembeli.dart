import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/client/transaksi_client.dart';
import 'package:flutter_application_reusemart/entity/TransaksiPenjualan2.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

enum DateFilterOptions { last7Days, last30Days, custom }

class HistoryPembeli extends StatefulWidget {
  const HistoryPembeli({super.key});

  @override
  State<HistoryPembeli> createState() => _HistoryPembeliState();
}

class _HistoryPembeliState extends State<HistoryPembeli> {
  static const String baseUrl = 'https://reusemartshop.sikoding.id';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  List<TransaksiPenjualan2> _transactions = [];
  bool _isLoading = true;
  bool _isDateFormatInitialized = false;
  String? _errorMessage;
  DateFilterOptions _activeFilter = DateFilterOptions.last30Days;
  final Color blue600 = const Color(0xFF2563EB);

  @override
  void initState() {
    super.initState();
    _initializeDateFormat().then((_) {
      setState(() => _isDateFormatInitialized = true);
      _fetchHistory();
    });
  }

  Future<void> _initializeDateFormat() async {
    await initializeDateFormatting('id_ID', null);
  }

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _CalendarRangePickerSheet(
          initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
        ),
      ),
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
      switch (filter) {
        case DateFilterOptions.last7Days:
          _startDate = DateTime.now().subtract(const Duration(days: 7));
          _endDate = DateTime.now();
          break;
        case DateFilterOptions.last30Days:
          _startDate = DateTime.now().subtract(const Duration(days: 30));
          _endDate = DateTime.now();
          break;
        case DateFilterOptions.custom:
          break;
      }
      _fetchHistory();
    });
  }

  Future<void> _fetchHistory() async {
    if (!_isDateFormatInitialized) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final transactions = await TransaksiClient.fetchHistory(
        DateFormat('yyyy-MM-dd').format(_startDate),
        DateFormat('yyyy-MM-dd').format(_endDate),
      );
      setState(() => _transactions = transactions);
    } catch (e) {
      setState(() => _errorMessage = "Gagal memuat transaksi. Silakan coba lagi.");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildFilterChip(String label, DateFilterOptions filter) {
    final bool isSelected = _activeFilter == filter;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => _onFilterChanged(filter),
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildTransactionCard(TransaksiPenjualan2 trx) {
    double totalProduk = trx.detailTransaksi.fold(0, (sum, item) {
      final hargaSatuan = item.barang?.hargaBarang ?? 0.0;
      return sum + (hargaSatuan * 1);
    });
    double grandTotal = totalProduk + trx.ongkir;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'No. ${trx.noNota}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                _buildStatusBadge(trx.statusTransaksi),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                  .format(DateTime.parse(trx.tanggalTransaksi)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...trx.detailTransaksi.map((detail) {
              final barang = detail.barang!;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: barang.fotoBarang != null
                          ? Image.network(
                              '$baseUrl${barang.fotoBarang.first}',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey.shade100,
                                child: const Icon(Icons.shopping_bag, color: Colors.grey),
                              ),
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade100,
                              child: const Icon(Icons.shopping_bag, color: Colors.grey),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            barang.namaBarang,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '1 × Rp${NumberFormat('#,###').format(barang.hargaBarang)}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Rp${NumberFormat('#,###').format(barang.hargaBarang)}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }),
            const Divider(height: 24),
            _buildSummaryRow('Subtotal', 
                'Rp${NumberFormat('#,###').format(totalProduk)}'),
            _buildSummaryRow('Ongkos Kirim',
                'Rp${NumberFormat('#,###').format(trx.ongkir)}'),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Total',
              'Rp${NumberFormat('#,###').format(grandTotal)}',
              isBold: true,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_border, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('+${trx.poinDapat} Poin',
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  backgroundColor: Colors.amber.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                _buildPaymentStatusChip(trx.statusPembayaran),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color ?? Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    
    if (status.toLowerCase().contains('selesai')) {
      bgColor = Colors.green.shade50;
      textColor = Colors.green.shade800;
    } else if (status.toLowerCase().contains('dikirim')) {
      bgColor = Colors.blue.shade50;
      textColor = Colors.blue.shade800;
    } else if (status.toLowerCase().contains('diproses')) {
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange.shade800;
    } else if (status.toLowerCase().contains('batal')) {
      bgColor = Colors.red.shade50;
      textColor = Colors.red.shade800;
    } else {
      bgColor = Colors.grey.shade100;
      textColor = Colors.grey.shade800;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPaymentStatusChip(String status) {
    Color bgColor;
    Color textColor;
    
    if (status.toLowerCase() == 'lunas') {
      bgColor = Colors.green.shade50;
      textColor = Colors.green.shade800;
    } else if (status.toLowerCase() == 'belum lunas') {
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange.shade800;
    } else {
      bgColor = Colors.grey.shade100;
      textColor = Colors.grey.shade800;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (_, index) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDateFormatInitialized) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: blue600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: _isLoading
                ? _buildLoadingIndicator()
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _fetchHistory,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _transactions.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_long, size: 100, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                const Text(
                                  'Tidak ada transaksi ditemukan',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Transaksi antara ${DateFormat('d MMM yyyy').format(_startDate)} - ${DateFormat('d MMM yyyy').format(_endDate)} tidak ditemukan',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchHistory,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _transactions.length,
                              itemBuilder: (_, index) => 
                                  _buildTransactionCard(_transactions[index]),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Periode Transaksi",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip("7 Hari", DateFilterOptions.last7Days),
                _buildFilterChip("30 Hari", DateFilterOptions.last30Days),
              ],
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _selectCustomDateRange(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${DateFormat('d MMM yyyy', 'id_ID').format(_startDate)} - ${DateFormat('d MMM yyyy', 'id_ID').format(_endDate)}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Icon(Icons.calendar_today, size: 18, color: Theme.of(context).primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarRangePickerSheet extends StatefulWidget {
  final DateTimeRange initialDateRange;

  const _CalendarRangePickerSheet({required this.initialDateRange});

  @override
  State<_CalendarRangePickerSheet> createState() => _CalendarRangePickerSheetState();
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
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Pilih Rentang Tanggal',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            rangeSelectionMode: RangeSelectionMode.toggledOn,
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _rangeStart = start;
                _rangeEnd = end;
                _focusedDay = focusedDay;
              });
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: const Icon(Icons.chevron_left),
              rightChevronIcon: const Icon(Icons.chevron_right),
              headerPadding: const EdgeInsets.symmetric(vertical: 8),
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            calendarStyle: CalendarStyle(
              rangeHighlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
              rangeStartDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              withinRangeTextStyle: const TextStyle(color: Colors.black),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.grey.shade600),
              weekendStyle: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Terapkan'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}