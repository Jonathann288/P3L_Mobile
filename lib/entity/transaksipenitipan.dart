// lib/entity/transaksipenitipan.dart

// Nama class diubah dari HistoryTitipan menjadi TransaksiPenitipanHistory
class TransaksiPenitipanHistory {
  final String idBarang;
  final String namaBarang;
  final String? statusBarang;
  final String? fotoBarang;
  final String tanggalPenitipan;
  final String tanggalAkhirPenitipan;

  TransaksiPenitipanHistory({
    required this.idBarang,
    required this.namaBarang,
    this.statusBarang,
    this.fotoBarang,
    required this.tanggalPenitipan,
    required this.tanggalAkhirPenitipan,
  });

  factory TransaksiPenitipanHistory.fromJson(Map<String, dynamic> json) {
    return TransaksiPenitipanHistory(
      idBarang: json['id_barang'].toString(),
      namaBarang: json['nama_barang'],
      statusBarang: json['status_barang'],
      fotoBarang: json['foto_barang'],
      tanggalPenitipan: json['tanggal_penitipan'],
      tanggalAkhirPenitipan: json['tanggal_akhir_penitipan'],
    );
  }
}