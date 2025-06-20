import 'package:flutter_application_reusemart/entity/Pegawai.dart';
import 'package:flutter_application_reusemart/entity/Pembeli.dart';
import 'package:flutter_application_reusemart/entity/DetailTransaksiPenjualan.dart';

class TransaksiPenjualan {
  final int? idTransaksiPenjualan;
  final int? idPembeli;
  final int? idPegawai;
  final DateTime? tanggalTransaksi;
  final String? metodePengantaran;
  final DateTime? tanggalLunas;
  final String? buktiPembayaran;
  final String? statusPembayaran;
  final int? poin;
  final DateTime? tanggalKirim;
  final double? ongkir;
  final String? statusTransaksi;
  final int? idKurir;
  final DateTime? tanggalAmbil;
  final String? noNota;
  final int? poinDapat;

  final Pegawai? pegawai;
  final Pegawai? kurir;
  final Pembeli? pembeli;
  final List<DetailTransaksiPenjualan>? detailTransaksi;

  TransaksiPenjualan({
    this.idTransaksiPenjualan,
    this.idPembeli,
    this.idPegawai,
    this.tanggalTransaksi,
    this.metodePengantaran,
    this.tanggalLunas,
    this.buktiPembayaran,
    this.statusPembayaran,
    this.poin,
    this.tanggalKirim,
    this.ongkir,
    this.statusTransaksi,
    this.idKurir,
    this.tanggalAmbil,
    this.noNota,
    this.poinDapat,
    this.pegawai,
    this.kurir,
    this.pembeli,
    this.detailTransaksi,
  });

  factory TransaksiPenjualan.fromJson(Map<String, dynamic> json) {
    return TransaksiPenjualan(
      idTransaksiPenjualan: json['id_transaksi_penjualan'],
      idPembeli: json['id_pembeli'],
      idPegawai: json['id_pegawai'],
      tanggalTransaksi: json['tanggal_transaksi'] != null
          ? DateTime.parse(json['tanggal_transaksi'])
          : null,
      metodePengantaran: json['metode_pengantaran'],
      tanggalLunas: json['tanggal_lunas'] != null
          ? DateTime.parse(json['tanggal_lunas'])
          : null,
      buktiPembayaran: json['bukti_pembayaran'],
      statusPembayaran: json['status_pembayaran'],
      poin: json['poin'],
      tanggalKirim: json['tanggal_kirim'] != null
          ? DateTime.parse(json['tanggal_kirim'])
          : null,
      ongkir: (json['ongkir'] as num?)?.toDouble(),
      statusTransaksi: json['status_transaksi'],
      idKurir: json['id_kurir'],
      tanggalAmbil: json['tanggal_ambil'] != null
          ? DateTime.parse(json['tanggal_ambil'])
          : null,
      noNota: json['no_nota'],
      poinDapat: json['poin_dapat'],
      pegawai: json['pegawai'] != null ? Pegawai.fromJson(json['pegawai']) : null,
      kurir: json['kurir'] != null ? Pegawai.fromJson(json['kurir']) : null,
      pembeli: json['pembeli'] != null ? Pembeli.fromJson(json['pembeli']) : null,
      detailTransaksi: json['detail_transaksi'] != null
          ? List<DetailTransaksiPenjualan>.from(json['detail_transaksi']
              .map((x) => DetailTransaksiPenjualan.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_transaksi_penjualan': idTransaksiPenjualan,
      'id_pembeli': idPembeli,
      'id_pegawai': idPegawai,
      'tanggal_transaksi': tanggalTransaksi?.toIso8601String(),
      'metode_pengantaran': metodePengantaran,
      'tanggal_lunas': tanggalLunas?.toIso8601String(),
      'bukti_pembayaran': buktiPembayaran,
      'status_pembayaran': statusPembayaran,
      'poin': poin,
      'tanggal_kirim': tanggalKirim?.toIso8601String(),
      'ongkir': ongkir,
      'status_transaksi': statusTransaksi,
      'id_kurir': idKurir,
      'tanggal_ambil': tanggalAmbil?.toIso8601String(),
      'no_nota': noNota,
      'poin_dapat': poinDapat,
      'pegawai': pegawai?.toJson(),
      'kurir': kurir?.toJson(),
      'pembeli': pembeli?.toJson(),
      'detail_transaksi': detailTransaksi?.map((x) => x.toJson()).toList(),
    };
  }
}
