import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/client/BarangClient.dart';
import 'package:flutter_application_reusemart/entity/Barang.dart';
import 'entity/Kategori_barang.dart';
import 'package:flutter_application_reusemart/login_page.dart';
import 'detailBarang.dart';

class HomePembeli extends StatefulWidget {
  const HomePembeli({super.key});

  @override
  State<HomePembeli> createState() => _HomePembeliState();
}

class _HomePembeliState extends State<HomePembeli> {
  static const String baseUrl = 'https://reusemartshop.sikoding.id/';
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
        automaticallyImplyLeading: false,
        title: Image.asset('images/logo6.png', height: 40),
        centerTitle: true,
        backgroundColor: blue600,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
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
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: kategoris.length,
                            itemBuilder: (context, index) {
                              final kategori = kategoris[index];
                              final imageUrl = index < images.length ? images[index] : null;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.orange[100],
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.orange.withOpacity(0.3),
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
                                                  size: 30,
                                                ),
                                              ),
                                            )
                                          : const Icon(
                                              Icons.category,
                                              size: 30,
                                              color: Colors.orange,
                                            ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        kategori.namaKategori,
                                        style: const TextStyle(
                                          fontSize: 11,
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
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: barangs.length,
                            itemBuilder: (context, index) {
                              final barang = barangs[index];
                              return InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () => _openDetailBarang(barang.idBarang),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                              width: double.infinity,
                                              color: Colors.grey[200],
                                              child: barang.fotoBarang.isNotEmpty
                                                  ? Image.network(
                                                      '$baseUrl${barang.fotoBarang.first}',
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) =>
                                                          const Icon(Icons.broken_image, size: 40),
                                                    )
                                                  : const Icon(Icons.image, size: 40),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          barang.namaBarang,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Rp ${barang.hargaBarang}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue[800],
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text('Add to Cart', style: TextStyle(fontSize: 14)),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                ),
                              );
                            },
                          ),
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
          _navItem(Icons.store, "Top Seller", Colors.red, context, '/topseller'),
          _navItem(Icons.history, "History", Colors.pink, context, '/history_pembeli'),
          _navItem(Icons.person, "Profil", Colors.blue, context, '/profil'),
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