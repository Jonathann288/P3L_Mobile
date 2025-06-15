import 'package:flutter/material.dart';

class HomePegawai extends StatelessWidget {
  const HomePegawai({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> barangList = [
      {'nama': 'Kaos ReuseMart', 'harga': 50000},
      {'nama': 'Botol Bekas', 'harga': 15000},
      {'nama': 'Tas Rajut', 'harga': 75000},
    ];

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Beranda Pegawai'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: barangList.length,
              itemBuilder: (context, index) {
                final barang = barangList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      barang['nama'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Harga: Rp ${barang['harga']}',
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label, 
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}