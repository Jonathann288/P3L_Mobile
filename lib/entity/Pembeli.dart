class Pembeli {
  final int? idPembeli;          // id_pembeli (primary key)
  final String? namaPembeli;
  final String? tanggalLahir;    // biasanya String format "YYYY-MM-DD"
  final String? emailPembeli;
  final String? passwordPembeli; // biasanya tidak dikirim ke client, tapi saya sertakan jika perlu
  final String? nomorTeleponPembeli;
  final int? totalPoin;
  final String? fotoPembeli;

  Pembeli({
    this.idPembeli,
    this.namaPembeli,
    this.tanggalLahir,
    this.emailPembeli,
    this.passwordPembeli,
    this.nomorTeleponPembeli,
    this.totalPoin,
    this.fotoPembeli,
  });

  // Factory constructor untuk parse dari JSON (misal dari API)
  factory Pembeli.fromJson(Map<String, dynamic> json) {
    return Pembeli(
      idPembeli: int.tryParse(json['id_pembeli']?.toString() ?? json['id']?.toString() ?? ''),
      namaPembeli: json['nama_pembeli'],
      tanggalLahir: json['tanggal_lahir'],
      emailPembeli: json['email_pembeli'],
      passwordPembeli: json['password_pembeli'],
      nomorTeleponPembeli: json['nomor_telepon_pembeli'],
      totalPoin: json['total_poin'] != null ? int.tryParse(json['total_poin'].toString()) : 0,
      fotoPembeli: json['foto_pembeli'],
    );
  }


  // Convert object ke JSON (misal untuk request)
  Map<String, dynamic> toJson() {
    return {
      'id_pembeli': idPembeli,
      'nama_pembeli': namaPembeli,
      'tanggal_lahir': tanggalLahir,
      'email_pembeli': emailPembeli,
      'password_pembeli': passwordPembeli,
      'nomor_telepon_pembeli': nomorTeleponPembeli,
      'total_poin': totalPoin,
      'foto_pembeli': fotoPembeli,
    };
  }
}
