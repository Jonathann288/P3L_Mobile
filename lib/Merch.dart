import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/entity/Merchendise.dart';
import 'package:flutter_application_reusemart/client/MerchendiseClient.dart';
 const url = 'http://10.0.2.2:8000/';
class MerchPage extends StatefulWidget {
  @override
  _MerchPageState createState() => _MerchPageState();

}

class _MerchPageState extends State<MerchPage> {
  late Future<List<Merchandise>> futureMerchandise;

  @override
  void initState() {
    super.initState();
    futureMerchandise = MerchendiseClient.fetchMerchandise();
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
            // Loading indicator saat data belum datang
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Tampilkan error jika ada
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Jika data kosong
            return Center(child: Text('Data merchandise kosong'));
          } else {
            // Jika data ada, tampilkan dalam list
            final merchandiseList = snapshot.data!;
            return ListView.builder(
              itemCount: merchandiseList.length,
              itemBuilder: (context, index) {
                final item = merchandiseList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: ListTile(
                    leading: Image.network(
                      // Gunakan base URL client + path foto
                      '$url${item.fotoMerchandise.startsWith('/') ? '' : '/'}${item.fotoMerchandise}',
                      width: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image),
                    ),
                    title: Text(item.namaMerchandise),
                    subtitle: Text('Poin: ${item.poinMerchandise}\nStok: ${item.stokMerchandise}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
