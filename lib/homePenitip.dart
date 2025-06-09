import 'package:flutter/material.dart';

class HomePenitip extends StatelessWidget {
  const HomePenitip({super.key});

  @override
  Widget build(BuildContext context) {
    // Data ini hanya contoh, nantinya bisa diambil dari API
    final List<Map<String, dynamic>> barangList = [
      {'nama': 'Kaos ReuseMart', 'harga': 50000},
      {'nama': 'Botol Bekas', 'harga': 15000},
      {'nama': 'Tas Rajut', 'harga': 75000},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF33AADD), // Latar biru
      appBar: AppBar(
        title: const Text('Beranda Penitip'),
        backgroundColor: const Color.fromARGB(255, 240, 242, 245),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Daftar Barang Dijual',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: barangList.length,
              itemBuilder: (context, index) {
                final barang = barangList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(
                      barang['nama'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Harga: Rp ${barang['harga']}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Aksi beli / lihat detail
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Beli'),
                    ),
                  ),
                );
              },
            ),
          ),
          // Navigasi bawah diletakkan di luar Column agar tetap di bawah
        ],
      ),
      // Gunakan bottomNavigationBar agar posisinya tetap di bawah
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Widget untuk membuat bottom navigation bar
  Widget _buildBottomNavBar(BuildContext context) {
    // SafeArea memastikan UI tidak tertutup oleh notch atau bar sistem
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16), // Margin di bawah
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Nama route sudah disesuaikan dengan progress terakhir
            _navItem(Icons.store, "Merch", Colors.blue, context, '/merchandise'),
            _navItem(Icons.history, "History", Colors.blue, context, '/history_penitip'),
            _navItem(Icons.person, "Profil", Colors.blue, context, '/profil'),
          ],
        ),
      ),
    );
  }

  // Widget untuk setiap item di dalam navigation bar
  Widget _navItem(
    IconData icon,
    String label,
    Color color,
    BuildContext context,
    String routeName,
  ) {
    return GestureDetector(
      onTap: () {
        // Gunakan pushNamed agar ada tombol kembali otomatis di AppBar
        Navigator.pushNamed(context, routeName);
      },
      // Column ini untuk menumpuk Icon dan Text secara vertikal
      child: Column(
        mainAxisSize: MainAxisSize.min, // Membuat ukuran column sekecil mungkin
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
