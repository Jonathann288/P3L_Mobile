import 'package:flutter_application_reusemart/entity/Barang.dart';
import 'package:flutter_application_reusemart/entity/TransaksiPenjualan.dart';
import 'package:flutter_application_reusemart/entity/TransaksiPenitipan.dart';

class DetailTransaksiPenjualan {
  final int? idDetailTransaksiPenjualan;
  final int? idTransaksiPenjualan;
  final int? idBarang;
  final double? totalHarga;
  final int? ratingUntukPenitip;

  final TransaksiPenjualan? transaksiPenjualan;
  final Barang? barang;
  final TransaksiPenitipan? transaksiPenitipan;

  DetailTransaksiPenjualan({
    this.idDetailTransaksiPenjualan,
    this.idTransaksiPenjualan,
    this.idBarang,
    this.totalHarga,
    this.ratingUntukPenitip,
    this.transaksiPenjualan,
    this.barang,
    this.transaksiPenitipan,
  });

  factory DetailTransaksiPenjualan.fromJson(Map<String, dynamic> json) {
    return DetailTransaksiPenjualan(
      idDetailTransaksiPenjualan: json['id_detail_transaksi_penjualan'],
      idTransaksiPenjualan: json['id_transaksi_penjualan'],
      idBarang: json['id_barang'],
      totalHarga: (json['total_harga'] as num?)?.toDouble(),
      ratingUntukPenitip: json['rating_untuk_penitip'],
      transaksiPenjualan: json['transaksipenjualan'] != null
          ? TransaksiPenjualan.fromJson(json['transaksipenjualan'])
          : null,
      barang: json['barang'] != null
          ? Barang.fromJson(json['barang'])
          : null,
      transaksiPenitipan: json['transaksi_penitipan'] != null
          ? TransaksiPenitipan.fromJson(json['transaksi_penitipan'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_detail_transaksi_penjualan': idDetailTransaksiPenjualan,
      'id_transaksi_penjualan': idTransaksiPenjualan,
      'id_barang': idBarang,
      'total_harga': totalHarga,
      'rating_untuk_penitip': ratingUntukPenitip,
      'transaksipenjualan': transaksiPenjualan?.toJson(),
      'barang': barang?.toJson(),
      'transaksi_penitipan': transaksiPenitipan?.toJson(),
    };
  }
}
