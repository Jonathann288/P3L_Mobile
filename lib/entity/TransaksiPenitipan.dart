import 'package:flutter_application_reusemart/entity/Pegawai.dart';
import 'package:flutter_application_reusemart/entity/Penitip.dart';
import 'package:flutter_application_reusemart/entity/DetailTransaksiPenitipan.dart';

class TransaksiPenitipan {
  final int? idTransaksiPenitipan;
  final int? id;
  final int? idPegawai;
  final int? idPenitip;
  final DateTime? tanggalPenitipan;
  final DateTime? tanggalAkhirPenitipan;
  final DateTime? tanggalBatasPengambilan;
  final DateTime? tanggalPengambilanBarang;

  final Pegawai? pegawai;
  final Penitip? penitip;
  final List<DetailTransaksiPenitipan>? detailTransaksiPenitipan;

  TransaksiPenitipan({
    this.idTransaksiPenitipan,
    this.id,
    this.idPegawai,
    this.idPenitip,
    this.tanggalPenitipan,
    this.tanggalAkhirPenitipan,
    this.tanggalBatasPengambilan,
    this.tanggalPengambilanBarang,
    this.pegawai,
    this.penitip,
    this.detailTransaksiPenitipan,
  });

  factory TransaksiPenitipan.fromJson(Map<String, dynamic> json) {
    return TransaksiPenitipan(
      idTransaksiPenitipan: json['id_transaksi_penitipan'],
      id: json['id'],
      idPegawai: json['id_pegawai'],
      idPenitip: json['id_penitip'],
      tanggalPenitipan: json['tanggal_penitipan'] != null
          ? DateTime.parse(json['tanggal_penitipan'])
          : null,
      tanggalAkhirPenitipan: json['tanggal_akhir_penitipan'] != null
          ? DateTime.parse(json['tanggal_akhir_penitipan'])
          : null,
      tanggalBatasPengambilan: json['tanggal_batas_pengambilan'] != null
          ? DateTime.parse(json['tanggal_batas_pengambilan'])
          : null,
      tanggalPengambilanBarang: json['tanggal_pengambilan_barang'] != null
          ? DateTime.parse(json['tanggal_pengambilan_barang'])
          : null,
      pegawai: json['pegawai'] != null ? Pegawai.fromJson(json['pegawai']) : null,
      penitip: json['penitip'] != null ? Penitip.fromJson(json['penitip']) : null,
      detailTransaksiPenitipan: json['detailtransaksipenitipan'] != null
          ? List<DetailTransaksiPenitipan>.from(json['detailtransaksipenitipan']
              .map((x) => DetailTransaksiPenitipan.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_transaksi_penitipan': idTransaksiPenitipan,
      'id': id,
      'id_pegawai': idPegawai,
      'id_penitip': idPenitip,
      'tanggal_penitipan': tanggalPenitipan?.toIso8601String(),
      'tanggal_akhir_penitipan': tanggalAkhirPenitipan?.toIso8601String(),
      'tanggal_batas_pengambilan': tanggalBatasPengambilan?.toIso8601String(),
      'tanggal_pengambilan_barang': tanggalPengambilanBarang?.toIso8601String(),
      'pegawai': pegawai?.toJson(),
      'penitip': penitip?.toJson(),
      'detailtransaksipenitipan':
          detailTransaksiPenitipan?.map((x) => x.toJson()).toList(),
    };
  }
}
