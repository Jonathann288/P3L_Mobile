class Merchandise {
  final int idMerchandise;
  final int idPegawai;
  final int id;
  final String namaMerchandise;
  final int stokMerchandise;
  final int poinMerchandise;
  final String fotoMerchandise;
  // Pastikan ini ada di API

  Merchandise({
    required this.idMerchandise,
    required this.idPegawai,
    required this.id,
    required this.namaMerchandise,
    required this.stokMerchandise,
    required this.poinMerchandise,
    required this.fotoMerchandise,
  });

  factory Merchandise.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Merchandise(
      idMerchandise: parseInt(json['id_merchandise']),
      idPegawai: parseInt(json['id_pegawai']),
      id: parseInt(json['id']),
      namaMerchandise: json['nama_merchandise'] ?? '',
      stokMerchandise: parseInt(json['stok_merchandise']),
      poinMerchandise: parseInt(json['harga_merchandise']),
      fotoMerchandise: json['foto_merchandise'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_merchandise': idMerchandise,
      'id_pegawai': idPegawai,
      'id': id,
      'nama_merchandise': namaMerchandise,
      'stok_merchandise': stokMerchandise,
      'harga_merchandise': poinMerchandise,
      'foto_merchandise': fotoMerchandise,
    };
  }
}