import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/entity/Merchendise.dart';
import 'package:flutter_application_reusemart/client/MerchendiseClient.dart';

class MerchPage extends StatefulWidget {
  @override
  _MerchPageState createState() => _MerchPageState();

  static const String baseUrl = 'http://10.0.2.2:8000';
}

class _MerchPageState extends State<MerchPage> {
  late Future<List<Merchandise>> futureMerchandise;

  @override
  void initState() {
    super.initState();
    futureMerchandise = MerchendiseClient.fetchMerchandise();
  }

  void _claimMerchandise(Merchandise item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Claim Merchandise'),
        content: Text(
          'Anda yakin ingin menukar ${item.poinMerchandise} poin untuk ${item.namaMerchandise}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog dulu
              _performClaimMerchandise(item); // panggil API terpisah
            },
            child: Text('Claim'),
          ),
        ],
      ),
    );
  }

  Future<void> _performClaimMerchandise(Merchandise item) async {
    final result = await MerchendiseClient.claimMerchandise(item.idMerchandise);

    if (!mounted) return; // Cek apakah widget masih aktif

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil menukar ${item.namaMerchandise}!'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        futureMerchandise = MerchendiseClient.fetchMerchandise();
      });
    } else {
      String errorMsg = result['message'] ?? 'Gagal klaim merchandise';
      if (result['errors'] != null) {
        errorMsg += '\n' + result['errors'].values.join(', ');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Merchandise'),
      ),
      body: FutureBuilder<List<Merchandise>>(
        future: futureMerchandise,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Data merchandise kosong'));
          } else {
            final merchandiseList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: merchandiseList.length,
                itemBuilder: (context, index) {
                  final item = merchandiseList[index];
                  final imageUrl = item.fotoMerchandise != null &&
                          item.fotoMerchandise.isNotEmpty
                      ? '${MerchPage.baseUrl}${item.fotoMerchandise.startsWith('/') ? '' : '/'}${item.fotoMerchandise}'
                      : '';
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                          child:
                                              Icon(Icons.broken_image, size: 50));
                                    },
                                  )
                                : Center(child: Icon(Icons.image, size: 50)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.namaMerchandise,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text('Poin: ${item.poinMerchandise}'),
                              Text('Stok: ${item.stokMerchandise}'),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                          child: ElevatedButton(
                            onPressed: () => _claimMerchandise(item),
                            child: Text('Claim'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
