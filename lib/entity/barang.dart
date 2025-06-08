// File: lib/entity/barang.dart
class Barang {
  final int id;
  final String nama;
  final double hargaBarang;
  final List<String> fotoBarang;

  Barang({
    required this.id,
    required this.nama,
    required this.hargaBarang,
    required this.fotoBarang,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    List<String> fotoList = [];
    if (json['foto_barang'] != null && json['foto_barang'] is List) {
      for (var item in json['foto_barang']) {
        fotoList.add(item.toString());
      }
    }
    
    return Barang(
      id: json['id_barang'] ?? 0, // DIPERBAIKI
      nama: json['nama_barang'] ?? 'Nama Barang Tidak Tersedia',
      hargaBarang: double.tryParse(json['harga_barang'].toString()) ?? 0.0,
      fotoBarang: fotoList,
    );
  }

  String? get firstImage {
    return fotoBarang.isNotEmpty ? fotoBarang.first : null;
  }
}