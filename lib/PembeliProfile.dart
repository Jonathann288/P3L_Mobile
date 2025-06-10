import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/entity/Pembeli.dart';

class PembeliProfile extends StatelessWidget {
  final Pembeli pembeli;
  // PERUBAHAN: Warna utama diubah menjadi biru
  final Color primaryColor = Colors.blue;

  const PembeliProfile({super.key, required this.pembeli});

  @override
  Widget build(BuildContext context) {
    final String? fotoUrl = pembeli.fotoPembeli;

    // PERUBAHAN: Memformat tanggal lahir agar hanya menampilkan tanggal
    // Ini akan mengambil bagian pertama dari string jika ada spasi (misal: "2000-01-15 00:00:00" menjadi "2000-01-15")
    final String tanggalLahirFormatted =
        pembeli.tanggalLahir?.split(' ').first ?? "-";

    return Scaffold(
      // PERUBAHAN: Latar belakang disamakan dengan homePembeli
      backgroundColor: const Color(0xFF33AADD),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor,
              backgroundImage: (fotoUrl != null && fotoUrl.isNotEmpty)
                  ? NetworkImage("http://172.20.10.5/P3L/public/${fotoUrl}")
                  : null,
              child: (fotoUrl == null || fotoUrl.isEmpty)
                  ? Text(
                      pembeli.namaPembeli?.substring(0, 1).toUpperCase() ?? "?",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              pembeli.namaPembeli ?? "Nama Pengguna",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Ubah warna teks agar kontras
              ),
            ),
            const SizedBox(height: 4),
            Text(
              pembeli.emailPembeli ?? "email@example.com",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70, // Ubah warna teks agar kontras
              ),
            ),
            const SizedBox(height: 24),
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
                      title: "Total Poin",
                      value: pembeli.totalPoin?.toString() ?? "0",
                      iconColor: Colors.amber,
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(
                      icon: Icons.phone_android_rounded,
                      title: "Nomor Telepon",
                      value: pembeli.nomorTeleponPembeli ?? "-",
                    ),
                    const Divider(height: 20),
                    // PERUBAHAN: Menggunakan variabel tanggal lahir yang sudah diformat
                    _buildInfoRow(
                      icon: Icons.cake_rounded,
                      title: "Tanggal Lahir",
                      value: tanggalLahirFormatted,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit,
                    color: Colors.white), // pastikan ikon terlihat
                label: const Text("Edit Profil",
                    style: TextStyle(
                        color: Colors.white)), // pastikan teks terlihat
                onPressed: () {
                  // Tambahkan logika navigasi ke halaman edit profil
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
          ),
        ),
      ],
    );
  }
}
