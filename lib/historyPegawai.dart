import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/client/PegawaiClient.dart';
import 'package:intl/intl.dart';

late Future<List<dynamic>> transaksiFuture;
int loggedInPegawaiId = 5;

class HistoryPegawaiPage extends StatefulWidget {
  const HistoryPegawaiPage({super.key});

  @override
  State<HistoryPegawaiPage> createState() => _HistoryPegawaiPageState();
}

class _HistoryPegawaiPageState extends State<HistoryPegawaiPage>
    with TickerProviderStateMixin {
  final PegawaiClient client = PegawaiClient();
  late Future<List<dynamic>> transaksiFuture;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Map<String, bool> kirimLoadingStates = {};
  Map<String, bool> selesaiLoadingStates = {};
  Map<String, bool> sedangDikirimStates = {};

  List<dynamic> filteredTransaksiList = [];

  @override
  void initState() {
    super.initState();
    transaksiFuture = client.getHistoryPengantaran().then((data) {
      filteredTransaksiList = List.from(data); // Inisialisasi filtered list
      return data;
    });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void removeTransaksiFromList(String transaksiId) {
    setState(() {
      filteredTransaksiList.removeWhere(
          (transaksi) => transaksi.idTransaksi?.toString() == transaksiId);
      // Bersihkan juga states untuk transaksi yang dihapus
      kirimLoadingStates.remove(transaksiId);
      selesaiLoadingStates.remove(transaksiId);
      sedangDikirimStates.remove(transaksiId);
    });
  }

  Future<void> _showCompletionNotifications(String transaksiId) async {
    // Notifikasi untuk pembeli
    _showNotification(
      title: 'Pengantaran Selesai',
      body:
          'Barang yang Anda beli telah sampai di tujuan. Terima kasih telah berbelanja dengan kami!',
      payload: 'transaksi/$transaksiId',
    );

    // Notifikasi untuk penitip
    _showNotification(
      title: 'Pengantaran Selesai',
      body:
          'Barang Anda telah berhasil diterima oleh pembeli. Dana akan segera diproses.',
      payload: 'transaksi/$transaksiId',
    );
  }

  void _showNotification(
      {required String title, required String body, required String payload}) {
    // Implementasi notifikasi lokal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );

    // Jika Anda menggunakan Firebase Cloud Messaging (FCM), tambahkan kode pengiriman notifikasi push di sini
    // Contoh:
    // FirebaseMessaging.instance.sendMessage(
    //   to: '/topics/$userId',
    //   data: {
    //     'title': title,
    //     'body': body,
    //     'payload': payload,
    //   },
    // );
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '-';
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '-';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Color _getStatusColor(String? status) {
    final statusLower = status?.toLowerCase();
    if (statusLower == 'lunas' || statusLower == 'selesai') {
      return const Color(0xFF4CAF50);
    } else if (statusLower == 'dibatalkan') {
      return const Color(0xFFF44336);
    } else if (statusLower == 'diproses' || statusLower == 'pending') {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFF9E9E9E);
    }
  }

  IconData _getStatusIcon(String? status) {
    final statusLower = status?.toLowerCase();
    if (statusLower == 'lunas' || statusLower == 'selesai') {
      return Icons.check_circle;
    } else if (statusLower == 'dibatalkan') {
      return Icons.cancel;
    } else if (statusLower == 'diproses' || statusLower == 'pending') {
      return Icons.access_time;
    } else {
      return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF1565C0),
              Color(0xFF0D47A1),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Riwayat Pengantaran',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Kelola pengantaran Anda',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Content Area
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: FutureBuilder<List<dynamic>>(
                      future: transaksiFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingState();
                        } else if (snapshot.hasError) {
                          return _buildErrorState(snapshot.error.toString());
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return _buildEmptyState();
                        } else {
                          return _buildSuccessState(snapshot.data!);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Memuat riwayat pengantaran...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 60,
                color: Color(0xFFF44336),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Oops! Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tidak dapat memuat data riwayat pengantaran',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.local_shipping,
                size: 60,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Belum Ada Pengantaran',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Riwayat pengantaran Anda akan muncul di sini\nsetelah ada transaksi yang diantar',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(List<dynamic> transaksiList) {
    // Inisialisasi filteredTransaksiList jika kosong
    if (filteredTransaksiList.isEmpty && transaksiList.isNotEmpty) {
      filteredTransaksiList = List.from(transaksiList);
    }

    // Jika semua data sudah dihapus, tampilkan empty state
    if (filteredTransaksiList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: filteredTransaksiList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final transaksi = filteredTransaksiList[index];
        final status = transaksi.statusPembayaran?.toString() ?? '-';
        final statusColor = _getStatusColor(status);
        final statusIcon = _getStatusIcon(status);
        final transaksiId =
            transaksi.idTransaksi?.toString() ?? index.toString();

        // Dapatkan status untuk transaksi ini
        final isKirimPressed = kirimLoadingStates[transaksiId] ?? false;
        final isSelesaiPressed = selesaiLoadingStates[transaksiId] ?? false;
        final isSedangDikirim = sedangDikirimStates[transaksiId] ?? false;

        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutCubic,
          child: Card(
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Add navigation to detail page if needed
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with customer name and status
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF1976D2),
                                  Color(0xFF1565C0)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaksi.namaPembeli ?? 'Pelanggan',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: statusColor, width: 1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  statusIcon,
                                  size: 16,
                                  color: statusColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  status.toUpperCase(),
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Info details with enhanced styling
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildEnhancedInfoRow(
                              Icons.shopping_bag,
                              'Nama Barang',
                              (transaksi.barangList != null &&
                                      transaksi.barangList!.isNotEmpty)
                                  ? transaksi.barangList![0].namaBarang ?? '-'
                                  : '-',
                              Colors.blue.shade800,
                            ),
                            const Divider(height: 24),
                            _buildEnhancedInfoRow(
                              Icons.local_shipping,
                              'Metode Pengantaran',
                              transaksi.metodePengantaran ??
                                  'Tidak diketahui',
                              const Color(0xFF1976D2),
                            ),
                            const Divider(height: 24),
                            _buildEnhancedInfoRow(
                              Icons.calendar_today,
                              'Tanggal Kirim',
                              _formatDate(transaksi.tanggalTransaksi),
                              const Color(0xFF7B1FA2),
                            ),
                          ],
                        ),
                      ),

                      // Tombol "KIRIM" dan "SELESAIKAN PENGANTARAN"
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 2,
                          ),
                          onPressed: isKirimPressed || isSedangDikirim
                              ? null // disable jika sudah loading atau sudah ditekan
                              : () async {
                                  setState(() {
                                    kirimLoadingStates[transaksiId] = true;
                                  });

                                  if (transaksi.idTransaksi == null) {
                                    print("ID transaksi tidak ditemukan!");
                                    setState(() {
                                      kirimLoadingStates[transaksiId] = false;
                                    });
                                    return;
                                  }

                                  bool success = await PegawaiClient()
                                      .updateStatusTransaksi(
                                    transaksi.idTransaksi.toString(),
                                    "sedang_dikirim",
                                  );

                                  setState(() {
                                    kirimLoadingStates[transaksiId] = false;
                                  });

                                  if (success) {
                                    setState(() {
                                      sedangDikirimStates[transaksiId] = true;
                                    });

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Status 'Sedang dikirim' berhasil diperbarui")),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Gagal memperbarui status")),
                                    );
                                  }
                                },
                          child: isKirimPressed
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.local_shipping_outlined,
                                        size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'KIRIM',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSedangDikirim ? Colors.green : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 2,
                          ),
                          onPressed: isSedangDikirim && !isSelesaiPressed
                              ? () async {
                                  setState(() {
                                    selesaiLoadingStates[transaksiId] = true;
                                  });

                                  if (transaksi.idTransaksi == null) {
                                    print("ID transaksi tidak ditemukan!");
                                    setState(() {
                                      selesaiLoadingStates[transaksiId] =
                                          false;
                                    });
                                    return;
                                  }

                                  bool success = await PegawaiClient()
                                      .updateStatusTransaksi(
                                    transaksi.idTransaksi.toString(),
                                    "Selesai",
                                  );

                                  setState(() {
                                    selesaiLoadingStates[transaksiId] = false;
                                  });

                                  if (success) {
                                    setState(() {
                                      sedangDikirimStates[transaksiId] =
                                          false;
                                    });

                                    // Hapus transaksi dari list setelah berhasil selesai
                                    removeTransaksiFromList(transaksiId);

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Pengantaran selesai!")),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Gagal memperbarui status")),
                                    );
                                  }
                                }
                              : null,
                          child: isSelesaiPressed
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_outline,
                                        size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'SELESAI',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedInfoRow(
      IconData icon, String label, String value, Color iconColor,
      {bool isPrice = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: isPrice
                      ? const Color(0xFF388E3C)
                      : const Color(0xFF333333),
                  fontWeight: isPrice ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}