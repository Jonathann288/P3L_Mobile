class Komisi {
  final int? idKomisi;
  final int? idTransaksiPenjualan;
  final int? idPenitip;
  final int? idPegawai;
  final double? komisiPenitip;
  final double? komisiReusemart;
  final double? komisiHunter;

  Komisi({
    this.idKomisi,
    this.idTransaksiPenjualan,
    this.idPenitip,
    this.idPegawai,
    this.komisiPenitip,
    this.komisiReusemart,
    this.komisiHunter,
  });

  factory Komisi.fromJson(Map<String, dynamic> json) {
    return Komisi(
      idKomisi: json['id_komisi'],
      idTransaksiPenjualan: json['id_transaksi_penjualan'],
      idPenitip: json['id_penitip'],
      idPegawai: json['id_pegawai'],
      komisiPenitip: (json['komisi_penitip'] as num?)?.toDouble(),
      komisiReusemart: (json['komisi_reusemart'] as num?)?.toDouble(),
      komisiHunter: (json['komisi_hunter'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_komisi': idKomisi,
      'id_transaksi_penjualan': idTransaksiPenjualan,
      'id_penitip': idPenitip,
      'id_pegawai': idPegawai,
      'komisi_penitip': komisiPenitip,
      'komisi_reusemart': komisiReusemart,
      'komisi_hunter': komisiHunter,
    };
  }
}
