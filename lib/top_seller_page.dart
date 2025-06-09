import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/client/topseller_client.dart';
import 'package:flutter_application_reusemart/entity/Penitip.dart';
import 'package:flutter_application_reusemart/entity/topseller_data.dart';
import 'package:intl/intl.dart';

class TopSellerPage extends StatefulWidget {
  const TopSellerPage({super.key});

  @override
  State<TopSellerPage> createState() => _TopSellerPageState();
}

class _TopSellerPageState extends State<TopSellerPage> {
  late Future<TopSellerData> _topSellerFuture;

  @override
  void initState() {
    super.initState();
    _topSellerFuture = TopSellerClient.fetchTopSellers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeri Top Seller'),
        backgroundColor: const Color(0xFF33AADD),
      ),
      backgroundColor: const Color(0xFFF0F2F5),
      body: FutureBuilder<TopSellerData>(
        future: _topSellerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("Tidak ada data."));
          }

          final data = snapshot.data!;
          final currentSeller = data.currentMonthTopSeller;
          final historicalWinners = data.historicalWinners;

          if (currentSeller == null && historicalWinners.isEmpty) {
            return const Center(child: Text("Belum ada data Top Seller."));
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Kartu untuk Top Seller Bulan Ini (Sementara)
              if (currentSeller != null) ...[
                _buildTopSellerCard(
                  context,
                  title: 'TOP SELLER BULAN INI (Sementara)',
                  penitip: currentSeller,
                  isCurrentMonth: true,
                ),
                const SizedBox(height: 20),
              ],
              
              if (historicalWinners.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Pemenang Bulan-Bulan Sebelumnya',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Daftar Pemenang Historis
              ...historicalWinners.map((winnerDetails) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildTopSellerCard(
                    context,
                    title: 'PEMENANG - ${winnerDetails.monthName.toUpperCase()}',
                    penitip: winnerDetails.penitip,
                    isCurrentMonth: false,
                    details: winnerDetails,
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopSellerCard(BuildContext context, {required String title, required Penitip penitip, required bool isCurrentMonth, TopSellerDetails? details}) {
    final totalPenjualanFormatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(details?.totalPenjualanValue ?? 0);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: isCurrentMonth
                ? [Colors.amber.shade700, Colors.amber.shade400]
                : [Colors.indigo.shade700, Colors.indigo.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Text(
                penitip.namaPenitip?.substring(0, 1).toUpperCase() ?? '?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isCurrentMonth ? Colors.amber.shade800 : Colors.indigo.shade800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              penitip.namaPenitip ?? 'Nama Tidak Tersedia',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              penitip.emailPenitip ?? 'Email Tidak Tersedia',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            if (!isCurrentMonth && details != null) ...[
              const Divider(color: Colors.white54, height: 32, thickness: 1, indent: 20, endIndent: 20,),
              const Text('Bukti Kemenangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProofColumn(Icons.receipt_long, 'Transaksi Bulan Itu', details.totalTransaksi.toString()),
                  _buildProofColumn(Icons.monetization_on, 'Penjualan Bulan Itu', totalPenjualanFormatted),
                ],
              )
            ],
            const Divider(color: Colors.white54, height: 32, thickness: 1, indent: 20, endIndent: 20,),
            Text("Statistik Keseluruhan", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn(Icons.star, 'Rating', penitip.ratingPenitip?.toStringAsFixed(1) ?? 'N/A'),
                _buildInfoColumn(Icons.card_giftcard, 'Poin', penitip.totalPoin?.toString() ?? '0'),
                _buildInfoColumn(Icons.shopping_cart, 'Total Terjual', penitip.jumlahPenjualan?.toString() ?? '0'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // [PERBAIKAN] Implementasi widget dilengkapi
  Widget _buildProofColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
  
  // [PERBAIKAN] Implementasi widget dilengkapi
  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
