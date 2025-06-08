// File: lib/entity/detail_transaksi_penjualan.dart
import 'package:flutter_application_reusemart/entity/barang.dart';

class DetailTransaksiPenjualan {
  final int id;
  final int idTransaksiPenjualan;
  final int idBarang;
  final int jumlah;
  final double harga;
  final Barang? barang;

  DetailTransaksiPenjualan({
    required this.id,
    required this.idTransaksiPenjualan,
    required this.idBarang,
    required this.jumlah,
    required this.harga,
    this.barang,
  });

  factory DetailTransaksiPenjualan.fromJson(Map<String, dynamic> json) {
    return DetailTransaksiPenjualan(
      id: json['id_detail_transaksi_penjualan'] ?? 0, // DIPERBAIKI
      idTransaksiPenjualan: json['id_transaksi_penjualan'] ?? 0, // DIPERBAIKI
      idBarang: json['id_barang'] ?? 0, // DIPERBAIKI
      jumlah: json['jumlah'] ?? 1, // DIPERBAIKI
      harga: double.tryParse(json['harga'].toString()) ?? 0.0,
      barang: json['barang'] != null ? Barang.fromJson(json['barang']) : null,
    );
  }
}