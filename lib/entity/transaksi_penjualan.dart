class Alamat {
  final String? namaJalan;
  final String? deskripsiAlamat;
  final String? statusDefault;
  final String? kecamatan;

  Alamat({
    this.namaJalan,
    this.deskripsiAlamat,
    this.statusDefault,
    this.kecamatan,
  });

  factory Alamat.fromJson(Map<String, dynamic> json) {
    return Alamat(
      namaJalan: json['nama_jalan'],
      deskripsiAlamat: json['deskripsi_alamat'],
      statusDefault: json['status_default'],
      kecamatan: json['kecamatan'],
    );
  }
}

class BarangDetail {
  final String? namaBarang;
  final double? hargaBarang;
  final int? jumlah;

  BarangDetail({
    this.namaBarang,
    this.hargaBarang,
    this.jumlah,
  });

  factory BarangDetail.fromJson(Map<String, dynamic> json) {
    return BarangDetail(
      namaBarang: json['nama_barang'],
      hargaBarang: double.tryParse(json['harga_barang'].toString()), // Aman
      jumlah: (json['jumlah'] != null)
          ? int.tryParse(json['jumlah'].toString())
          : null,
    );
  }
}

class TransaksiPenjualan3 {
  final String? idTransaksi;
  final String? metodePengantaran;
  final String? tanggalTransaksi;
  final int? idPembeli;
  final String? statusPengiriman;
  final String? statusPembayaran;
  final List<BarangDetail>? barangList;
  final String? namaPembeli;
  final Alamat? alamatPengiriman; // Tambahkan field alamat

  TransaksiPenjualan3({
    this.idTransaksi,
    this.metodePengantaran,
    this.tanggalTransaksi,
    this.idPembeli,
    this.statusPengiriman,
    this.statusPembayaran,
    this.barangList,
    this.namaPembeli,
    this.alamatPengiriman, // Tambahkan ke constructor
  });

  factory TransaksiPenjualan3.fromJson(Map<String, dynamic> json) {
    List<BarangDetail> list = [];
    if (json['barang_list'] is List) {
      list = (json['barang_list'] as List)
          .map((item) => BarangDetail.fromJson(item))
          .toList();
    }


    return TransaksiPenjualan3(
      idTransaksi: json['id']?.toString(),
      metodePengantaran: json['metode_pengantaran'],
      tanggalTransaksi: json['tanggal_kirim'] ?? json['tanggal_transaksi'],
      idPembeli: int.tryParse(json['id_pembeli']?.toString() ?? ''),
      statusPengiriman: json['status_transaksi'],
      statusPembayaran: json['status_pembayaran'],
      barangList: list,
      namaPembeli: json['nama_pembeli'],
      alamatPengiriman: (json['alamat'] is Map)
          ? Alamat.fromJson(json['alamat'])
          : null,
 // Tambahkan parsing alamat
    );
  }
}

class TransaksiState {
  bool isKirimPressed;
  bool isSelesaiPressed;
  bool isSedangDikirim;

  TransaksiState({
    this.isKirimPressed = false,
    this.isSelesaiPressed = false,
    this.isSedangDikirim = false,
  });
}