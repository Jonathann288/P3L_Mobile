import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/entity/Barang.dart';
import 'package:intl/intl.dart';

class DetailBarang extends StatefulWidget {
  final Barang barang;

  final bool isElektronik;

  const DetailBarang({Key? key, required this.barang, required this.isElektronik}) : super(key: key);


  @override
  State<DetailBarang> createState() => _DetailBarangState();

  static const String baseUrl = 'https://reusemartshop.sikoding.id/';
}

class _DetailBarangState extends State<DetailBarang> {
  int currentIndex = 0;
  final Color blue600 = const Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    final fotoBarang = widget.barang.fotoBarang;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.barang.namaBarang,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: blue600,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (fotoBarang.isNotEmpty)
              SizedBox(
                height: 250,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      itemCount: fotoBarang.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final imageUrl = '${DetailBarang.baseUrl}${fotoBarang[index]}';
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 50),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(fotoBarang.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentIndex == index ? 12 : 8,
                            height: currentIndex == index ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentIndex == index ? Colors.blue : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.broken_image, size: 50),
              ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.barang.namaBarang,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(widget.barang.deskripsiBarang,
                        style: const TextStyle(fontSize: 16)),
                    const Divider(height: 32),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          widget.barang.ratingBarang.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(Icons.monitor_weight_outlined, color: Colors.blueGrey),
                        const SizedBox(width: 8),
                        Text('Berat: ${widget.barang.beratBarang} kg',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(Icons.price_change, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('Harga: Rp ${widget.barang.hargaBarang}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (widget.isElektronik) ...[
                      const Divider(height: 32),
                      Row(
                        children: const [
                          Icon(Icons.verified_user, color: Colors.teal),
                          SizedBox(width: 8),
                          Text('Garansi',
                              style:
                                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.barang.garansiBarang != null
                            ? DateFormat('dd MMMM yyyy').format(widget.barang.garansiBarang!)
                            : 'Tidak ada garansi',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
