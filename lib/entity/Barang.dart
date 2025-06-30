import 'package:flutter_application_reusemart/entity/Kategori_barang.dart';

class Barang {
  final int idBarang;
  final int idKategori;
  final String namaBarang;
  final List<String> fotoBarang;
  final double hargaBarang;
  final String deskripsiBarang;
  final int masaPenitipan;
  final String statusBarang;
  final double ratingBarang;
  final double beratBarang;
  final DateTime? garansiBarang;
  final KategoriBarang? kategori;
  final dynamic penitip; // Bisa diganti dengan model Penitip kalau ada

  Barang({
    required this.idBarang,
    required this.idKategori,
    required this.namaBarang,
    required this.fotoBarang,
    required this.hargaBarang,
    required this.deskripsiBarang,
    required this.masaPenitipan,
    required this.statusBarang,
    required this.ratingBarang,
    required this.beratBarang,
    this.garansiBarang,
    this.kategori,
    this.penitip,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      idBarang: int.parse(json['id_barang'].toString()),
      idKategori: int.parse(json['id_kategori'].toString()),
      namaBarang: json['nama_barang'],
      fotoBarang: (json['foto_barang'] as List).map((e) => e.toString()).toList(),
      hargaBarang: (json['harga_barang'] as num).toDouble(),
      deskripsiBarang: json['deskripsi_barang'] ?? '',
      masaPenitipan: int.tryParse(json['masa_penitipan'].toString()) ?? 0,
      statusBarang: json['status_barang'] ?? '',
      ratingBarang: (json['rating_barang'] as num?)?.toDouble() ?? 0.0,
      beratBarang: (json['berat_barang'] as num?)?.toDouble() ?? 0.0,
      garansiBarang: json['garansi_barang'] != null
          ? DateTime.tryParse(json['garansi_barang'])
          : null,
      kategori: json['kategori'] != null
          ? KategoriBarang.fromJson(json['kategori'])
          : null,
      penitip: json['penitip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_barang': idBarang,
      'id_kategori': idKategori,
      'nama_barang': namaBarang,
      'foto_barang': fotoBarang,
      'harga_barang': hargaBarang,
      'deskripsi_barang': deskripsiBarang,
      'masa_penitipan': masaPenitipan,
      'status_barang': statusBarang,
      'rating_barang': ratingBarang,
      'berat_barang': beratBarang,
      'garansi_barang': garansiBarang?.toIso8601String(),
      'kategori': kategori?.toJson(), // pastikan KategoriBarang punya toJson()
      'penitip': penitip, // jika penitip adalah class, ganti dengan penitip?.toJson()
    };
  }
}
