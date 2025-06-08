import 'package:flutter_application_reusemart/entity/Barang.dart';
import 'package:flutter_application_reusemart/entity/TransaksiPenitipan.dart';
import 'package:flutter_application_reusemart/entity/TransaksiPenjualan.dart';

class DetailTransaksiPenitipan {
  final int? idDetailTransaksiPenitipan;
  final int? idTransaksiPenitipan;
  final int? idBarang;
  final String? statusPerpanjangan;

  final TransaksiPenitipan? transaksiPenitipan;
  final Barang? barang;
  final TransaksiPenjualan? transaksiPenjualan;

  DetailTransaksiPenitipan({
    this.idDetailTransaksiPenitipan,
    this.idTransaksiPenitipan,
    this.idBarang,
    this.statusPerpanjangan,
    this.transaksiPenitipan,
    this.barang,
    this.transaksiPenjualan,
  });

  factory DetailTransaksiPenitipan.fromJson(Map<String, dynamic> json) {
    return DetailTransaksiPenitipan(
      idDetailTransaksiPenitipan: json['id_detail_transaksi_penitipan'],
      idTransaksiPenitipan: json['id_transaksi_penitipan'],
      idBarang: json['id_barang'],
      statusPerpanjangan: json['status_perpanjangan'],
      transaksiPenitipan: json['transaksipenitipan'] != null
          ? TransaksiPenitipan.fromJson(json['transaksipenitipan'])
          : null,
      barang: json['barang'] != null
          ? Barang.fromJson(json['barang'])
          : null,
      transaksiPenjualan: json['transaksipenjualan'] != null
          ? TransaksiPenjualan.fromJson(json['transaksipenjualan'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_detail_transaksi_penitipan': idDetailTransaksiPenitipan,
      'id_transaksi_penitipan': idTransaksiPenitipan,
      'id_barang': idBarang,
      'status_perpanjangan': statusPerpanjangan,
      'transaksipenitipan': transaksiPenitipan?.toJson(),
      'barang': barang?.toJson(),
      'transaksipenjualan': transaksiPenjualan?.toJson(),
    };
  }
}
