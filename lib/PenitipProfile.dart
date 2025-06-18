import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/entity/Penitip.dart';
import 'package:intl/intl.dart'; // Import paket intl untuk formatting angka

class PenitipProfile extends StatelessWidget {
  final Penitip penitip;
  // Warna utama disesuaikan agar konsisten
  final Color primaryColor = Colors.blue;

  const PenitipProfile({super.key, required this.penitip});

  @override
  Widget build(BuildContext context) {
    // Format tanggal lahir agar hanya menampilkan tanggal (YYYY-MM-DD)
    final String tanggalLahirFormatted =
        penitip.tanggalLahir?.split(' ').first ?? "-";

    // Format saldo agar lebih mudah dibaca
    final String saldoFormatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(penitip.saldoPenitip ?? 0);

    return Scaffold(
      // Latar belakang disamakan dengan contoh
      backgroundColor: const Color(0xFF33AADD),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar Profil
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor,
              child: Text(
                penitip.namaPenitip?.substring(0, 1).toUpperCase() ?? "?",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Nama Penitip
            Text(
              penitip.namaPenitip ?? "Nama Penitip",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            // Email Penitip
            Text(
              penitip.emailPenitip ?? "email@example.com",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Kartu yang berisi detail informasi
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.star_rounded,
                      title: "Rating",
                      value: penitip.ratingPenitip?.toStringAsFixed(1) ?? "0.0",
                      iconColor: Colors.amber,
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(
                      icon: Icons.credit_card,
                      title: "No. KTP",
                      value: penitip.nomorKtp ?? "-",
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(
                      icon: Icons.cake_rounded,
                      title: "Tanggal Lahir",
                      value: tanggalLahirFormatted,
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(
                      icon: Icons.account_balance_wallet_rounded,
                      title: "Saldo",
                      value: saldoFormatted,
                      iconColor: Colors.green,
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(
                      icon: Icons.loyalty_rounded,
                      title: "Total Poin",
                      value: penitip.totalPoin?.toString() ?? "0",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Tombol Edit Profil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  "Edit Profil",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // Tambahkan logika navigasi ke halaman edit profil di sini
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper baru untuk menampilkan baris informasi
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? primaryColor, size: 24),
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}