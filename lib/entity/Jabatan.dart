class Jabatan {
  final int? idJabatan;
  final String? namaJabatan;

  Jabatan({this.idJabatan, this.namaJabatan});

  factory Jabatan.fromJson(Map<String, dynamic> json) {
    int? parseId(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return Jabatan(
      idJabatan: parseId(json['id_jabatan'] ?? json['id']),
      namaJabatan: json['nama_jabatan'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id_jabatan': idJabatan,
      'nama_jabatan': namaJabatan,
    };
  }
}
