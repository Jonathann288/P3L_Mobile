// File: lib/entity/transaksipenjualan.dart
import 'package:flutter_application_reusemart/entity/detail_transaksi_penjualan.dart';

class TransaksiPenjualan {
  final int id;
  final String noNota;
  final String tanggalTransaksi;
  final String statusTransaksi;
  final String statusPembayaran;
  final String metodePengantaran;
  final double ongkir;
  final List<DetailTransaksiPenjualan> detailTransaksi;

  TransaksiPenjualan({
    required this.id,
    required this.noNota,
    required this.tanggalTransaksi,
    required this.statusTransaksi,
    required this.statusPembayaran,
    required this.metodePengantaran,
    required this.ongkir,
    required this.detailTransaksi,
  });

  factory TransaksiPenjualan.fromJson(Map<String, dynamic> json) {
    var detailList = json['detail_transaksi'] as List? ?? []; // Tambahkan ?? [] untuk keamanan
    List<DetailTransaksiPenjualan> detailTransaksiList =
        detailList.map((i) => DetailTransaksiPenjualan.fromJson(i)).toList();

    return TransaksiPenjualan(
      id: json['id_transaksi_penjualan'] ?? 0, // DIPERBAIKI
      noNota: json['no_nota'] ?? 'N/A',
      tanggalTransaksi: json['tanggal_transaksi'] ?? DateTime.now().toIso8601String(),
      statusTransaksi: json['status_transaksi'] ?? 'N/A',
      statusPembayaran: json['status_pembayaran'] ?? 'N/A',
      metodePengantaran: json['metode_pengantaran'] ?? 'N/A',
      ongkir: double.tryParse(json['ongkir'].toString()) ?? 0.0,
      detailTransaksi: detailTransaksiList,
    );
  }
}