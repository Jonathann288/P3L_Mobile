// File: lib/entity/transaksipenjualan.dart

import 'package:flutter_application_reusemart/entity/detail_transaksi_penjualan.dart'; 

class TransaksiPenjualan {
  final String? noNota;
  final String tanggalTransaksi;
  final String? metodePengantaran;
  final String statusPembayaran;
  final String statusTransaksi;
  final double ongkir;
  final int poinDapat; // <-- TAMBAHKAN FIELD INI
  final List<DetailTransaksiPenjualan> detailTransaksi;

  TransaksiPenjualan({
    required this.noNota,
    required this.tanggalTransaksi,
    this.metodePengantaran,
    required this.statusPembayaran,
    required this.statusTransaksi,
    required this.ongkir,
    required this.poinDapat, // <-- TAMBAHKAN DI CONSTRUCTOR
    required this.detailTransaksi,
  });

  factory TransaksiPenjualan.fromJson(Map<String, dynamic> json) {
    var listDetailJson = json['detail_transaksi'] as List? ?? [];
    List<DetailTransaksiPenjualan> detailItems = listDetailJson
        .map((item) => DetailTransaksiPenjualan.fromJson(item))
        .toList();

    return TransaksiPenjualan(
      noNota: json['no_nota'],
      tanggalTransaksi: json['tanggal_transaksi'] ?? '',
      metodePengantaran: json['metode_pengantaran'],
      statusPembayaran: json['status_pembayaran'] ?? 'Status Tidak Diketahui',
      statusTransaksi: json['status_transaksi'] ?? 'Status Tidak Diketahui',
      ongkir: double.tryParse(json['ongkir']?.toString() ?? '0.0') ?? 0.0,
      
      // <-- TAMBAHKAN LOGIKA PARSING UNTUK POIN -->
       poinDapat: num.tryParse(json['poin']?.toString() ?? '0')?.toInt() ?? 0,
      
      detailTransaksi: detailItems,
    );
  }
}