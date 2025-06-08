class KategoriBarang {
  final int idKategori;
  final String namaKategori;
  final String? namaSubKategori;

  KategoriBarang({
    required this.idKategori,
    required this.namaKategori,
    this.namaSubKategori,
  });

  factory KategoriBarang.fromJson(Map<String, dynamic> json) {
    return KategoriBarang(
      idKategori: json['id_kategori'],
      namaKategori: json['nama_kategori'],
      namaSubKategori: json['nama_sub_kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kategori': idKategori,
      'nama_kategori': namaKategori,
      'nama_sub_kategori': namaSubKategori,
    };
  }
}
