// lib/entity/transaksipenitipan.dart

class TransaksiPenitipanHistory {
  final String idBarang;
  final String namaBarang;
  final String? statusBarang;
  final String? fotoBarang;
  final String tanggalPenitipan;
  final String tanggalAkhirPenitipan;
  
  // --- DATA BARU ---
  final String? idTransaksiPenitipan;
  final double? hargaBarang;
  final String? tanggalBatasPengambilan;

  TransaksiPenitipanHistory({
    required this.idBarang,
    required this.namaBarang,
    this.statusBarang,
    this.fotoBarang,
    required this.tanggalPenitipan,
    required this.tanggalAkhirPenitipan,
    // --- TAMBAHKAN DI CONSTRUCTOR ---
    this.idTransaksiPenitipan,
    this.hargaBarang,
    this.tanggalBatasPengambilan,
  });

  factory TransaksiPenitipanHistory.fromJson(Map<String, dynamic> json) {
    return TransaksiPenitipanHistory(
      // --- DATA LAMA ---
      idBarang: json['id_barang']?.toString() ?? '',
      namaBarang: json['nama_barang'] ?? 'N/A',
      statusBarang: json['status_barang'],
      fotoBarang: json['foto_barang'],
      tanggalPenitipan: json['tanggal_penitipan'] ?? '-',
      tanggalAkhirPenitipan: json['tanggal_akhir_penitipan'] ?? '-',
      
      // --- PARSING DATA BARU ---
      idTransaksiPenitipan: json['id']?.toString(),
      hargaBarang: json['harga_barang'] != null ? double.tryParse(json['harga_barang'].toString()) : null,
      tanggalBatasPengambilan: json['tanggal_batas_pengambilan'],
    );
  }
}