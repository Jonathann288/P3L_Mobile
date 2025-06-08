import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/client/PegawaiClient.dart';

class HistoryHunter extends StatefulWidget {
  const HistoryHunter({Key? key}) : super(key: key);

  @override
  State<HistoryHunter> createState() => _HistoryHunterState();
}

class _HistoryHunterState extends State<HistoryHunter> {
  final PegawaiClient client = PegawaiClient();
  late Future<Map<String, dynamic>> futureData;
  final Color primaryColor = const Color(0xFF2563EB);
  final Color successColor = const Color(0xFF10B981);
  final Color warningColor = const Color(0xFFF59E0B);

  @override
  void initState() {
    super.initState();
    futureData = client.getKomisiHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            );
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red[400], size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat data komisi',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }
          
          if (!snapshot.hasData || (snapshot.data!['komisi'] as List).isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, color: Colors.grey[400], size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data komisi',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final namaPegawai = data['nama_pegawai'] ?? 'Tidak diketahui';
          final komisiList = (data['komisi'] as List).cast<Map<String, dynamic>>();

          return Column(
            children: [
              // Header with app-like appearance
              const SizedBox(height: 8),
              // Summary card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryColor.withOpacity(0.2),
                          child: Icon(Icons.person, color: primaryColor),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              namaPegawai,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              '${komisiList.length} Transaksi',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Transaction list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: komisiList.length,
                  itemBuilder: (context, index) {
                    return _buildKomisiCard(komisiList[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKomisiCard(Map<String, dynamic> komisi) {
    final statusTransaksi = komisi['status_transaksi']?.toString() ?? 'Tidak diketahui';
    final komisiHunter = komisi['komisi_hunter']?.toString() ?? '0';
    final namaBarang = komisi['nama_barang']?.toString() ?? 'Tidak diketahui';
    final isLunas = statusTransaksi == 'LUNAS';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    namaBarang,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLunas ? successColor.withOpacity(0.2) : warningColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusTransaksi,
                    style: TextStyle(
                      color: isLunas ? successColor : warningColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Komisi Hunter',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Rp $komisiHunter',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}