import 'package:flutter_application_reusemart/entity/detail_transaksi_penjualan.dart';

class TransaksiPenjualan2 {
  final String? noNota;
  final String tanggalTransaksi;
  final String? metodePengantaran;
  final String statusPembayaran;
  final String statusTransaksi;
  final double ongkir;
  final int poinDapat;
  final String? tanggalLunas; // <-- [PENTING] Properti ini harus ada

  final List<DetailTransaksiPenjualan> detailTransaksi;

  TransaksiPenjualan2({
    required this.noNota,
    required this.tanggalTransaksi,
    this.metodePengantaran,
    required this.statusPembayaran,
    required this.statusTransaksi,
    required this.ongkir,
    required this.poinDapat,
    this.tanggalLunas, // <-- [PENTING] Ditambahkan ke constructor
    required this.detailTransaksi,
  });

  factory TransaksiPenjualan2.fromJson(Map<String, dynamic> json) {
    var listDetailJson = json['detail_transaksi'] as List? ?? [];
    List<DetailTransaksiPenjualan> detailItems = listDetailJson
        .map((item) => DetailTransaksiPenjualan.fromJson(item))
        .toList();

    return TransaksiPenjualan2(
      noNota: json['no_nota'],
      tanggalTransaksi: json['tanggal_transaksi'] ?? '',
      metodePengantaran: json['metode_pengantaran'],
      statusPembayaran: json['status_pembayaran'] ?? 'Status Tidak Diketahui',
      statusTransaksi: json['status_transaksi'] ?? 'Status Tidak Diketahui',
      ongkir: double.tryParse(json['ongkir']?.toString() ?? '0.0') ?? 0.0,
      poinDapat: num.tryParse(json['poin_dapat']?.toString() ?? '0')?.toInt() ?? 0,
      tanggalLunas: json['tanggal_lunas'], // <-- [PENTING] Parsing data dari JSON
      detailTransaksi: detailItems,
    );
  }
}