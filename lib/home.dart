import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/client/BarangClient.dart';
import 'package:flutter_application_reusemart/entity/Barang.dart';
import 'entity/Kategori_barang.dart';
import 'package:flutter_application_reusemart/login_page.dart';
import 'detailBarang.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String baseUrl = 'http://10.0.2.2:8000/';
  List<KategoriBarang> kategoris = [];
  List<Barang> barangs = [];
  List<String> images = [];
  bool isLoading = true;
  String errorMessage = '';
  final Barangclient _barangClient = Barangclient();
  final Color blue600 = const Color(0xFF2563EB);
  @override
  void initState() {
    super.initState();
    fetchShopData();
  }

  Future<void> fetchShopData() async {
    try {
      final shopData = await _barangClient.fetchShopData();
      setState(() {
        kategoris = shopData['kategoris'];
        barangs = shopData['barang'];
        images = shopData['images'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal mengambil data shop: ${e.toString()}';
      });
    }
  }

  Future<void> _openDetailBarang(int idBarang) async {
    try {
      final result = await _barangClient.fetchBarangDetail(idBarang);
      final Barang fetchedBarang = result['barang'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBarang(
            barang: fetchedBarang,
            isElektronik: fetchedBarang.idKategori == 1,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuka detail: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/logo6.png',
          height: 40,
        ),
        centerTitle: true,
        backgroundColor: blue600,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80), // space for bottom nav
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kategori Section
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(  // <== tambah Center di sini
                            child: Text(
                              'Kategori',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 90, // dari 110 jadi 90
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: kategoris.length,
                            itemBuilder: (context, index) {
                              final kategori = kategoris[index];
                              final imageUrl = index < images.length ? images[index] : null;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0), // dikit diperkecil paddingnya
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60, // dari 80 jadi 60
                                      height: 60, // dari 80 jadi 60
                                      decoration: BoxDecoration(
                                        color: Colors.orange[100],
                                        borderRadius: BorderRadius.circular(12), // radius juga dikecilkan sedikit
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.orange.withOpacity(0.3), // blur dan opacity juga disesuaikan
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: imageUrl != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => const Icon(
                                                  Icons.broken_image,
                                                  color: Colors.orange,
                                                  size: 30, // icon juga lebih kecil
                                                ),
                                              ),
                                            )
                                          : const Icon(
                                              Icons.category,
                                              size: 30, // icon juga lebih kecil
                                              color: Colors.orange,
                                            ),
                                    ),
                                    const SizedBox(height: 4), // jarak dikurangi dari 6 jadi 4
                                    SizedBox(
                                      width: 60, // dari 80 jadi 60
                                      child: Text(
                                        kategori.namaKategori,
                                        style: const TextStyle(
                                          fontSize: 11, // font size dikecilkan dari 13 jadi 11
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const Divider(thickness: 5, color: Color(0xFF2563EB)),
                        // Rekomendasi Section
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(  // <== tambah Center di sini
                            child: Text(
                              'REKOMENDASI',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: barangs.length,
                          itemBuilder: (context, index) {
                            final barang = barangs[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  _openDetailBarang(barang.idBarang);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (barang.fotoBarang.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            '$baseUrl${barang.fotoBarang.first}',
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Container(
                                              height: 150,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.broken_image, size: 50),
                                            ),
                                          ),
                                        )
                                      else
                                        Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(Icons.broken_image, size: 50),
                                        ),
                                      const SizedBox(height: 12),
                                      Text(
                                        barang.namaBarang,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        barang.deskripsiBarang,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Rp ${barang.hargaBarang}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Add to cart logic
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          minimumSize: const Size(double.infinity, 45),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text(
                                          'Add to cart',
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          _navItem(Icons.store, "Merch", Colors.deepOrange, context, '/merchandise'),
          _navItem(Icons.history, "History", Colors.pink, context, '/history'),
          _navItem(Icons.person, "Profil", Colors.blue, context, '/login'),
        ],
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
