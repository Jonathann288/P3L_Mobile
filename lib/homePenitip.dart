import 'package:flutter/material.dart';

class HomePenitip extends StatelessWidget {
  const HomePenitip({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> barangList = [
      {'nama': 'Kaos ReuseMart', 'harga': 50000},
      {'nama': 'Botol Bekas', 'harga': 15000},
      {'nama': 'Tas Rajut', 'harga': 75000},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF33AADD), // latar biru
      appBar: AppBar(
        title: const Text('Beranda Penitip'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Daftar Barang Dijual',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: barangList.length,
              itemBuilder: (context, index) {
                final barang = barangList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(barang['nama']),
                    subtitle: Text('Harga: Rp ${barang['harga']}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // aksi beli / lihat detail
                      },
                      child: const Text('Beli'),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildBottomNavBar(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.store, "Merch", Colors.orange, context, '/merchandise'),
            _navItem(Icons.history, "History", Colors.pink, context, '/history'),
            _navItem(Icons.person, "Profil", Colors.blue, context, '/profil'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    Color color,
    BuildContext context,
    String routeName,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
