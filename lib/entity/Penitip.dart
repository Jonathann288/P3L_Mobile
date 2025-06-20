class Penitip {
  final int? idPenitip;
  final String? namaPenitip;
  final String? nomorKtp;
  final String? emailPenitip;
  final String? tanggalLahir;
  final String? passwordPenitip;   // biasanya tidak dikirimkan
  final String? nomorTeleponPenitip;
  final double? saldoPenitip;
  final int? totalPoin;
  final String? badge;
  final int? jumlahPenjualan;
  final String? fotoProfil;
  final double? ratingPenitip;
  final String? fotoKtp;

  Penitip({
    this.idPenitip,
    this.namaPenitip,
    this.nomorKtp,
    this.emailPenitip,
    this.tanggalLahir,
    this.passwordPenitip,
    this.nomorTeleponPenitip,
    this.saldoPenitip,
    this.totalPoin,
    this.badge,
    this.jumlahPenjualan,
    this.fotoProfil,
    this.ratingPenitip,
    this.fotoKtp,
  });

  factory Penitip.fromJson(Map<String, dynamic> json) {
    return Penitip(
      idPenitip: int.tryParse(json['id_penitip']?.toString() ?? json['id']?.toString() ?? ''),
      namaPenitip: json['nama_penitip'],
      nomorKtp: json['nomor_ktp'],
      emailPenitip: json['email_penitip'],
      tanggalLahir: json['tanggal_lahir'],
      passwordPenitip: json['password_penitip'],
      nomorTeleponPenitip: json['nomor_telepon_penitip'],
      saldoPenitip: json['saldo_penitip'] != null ? (json['saldo_penitip'] as num).toDouble() : null,
      totalPoin: json['total_poin'] != null ? int.tryParse(json['total_poin'].toString()) : null,
      badge: json['badge'],
      jumlahPenjualan: json['jumlah_penjualan'] != null ? int.tryParse(json['jumlah_penjualan'].toString()) : null,
      fotoProfil: json['foto_profil'],
      ratingPenitip: json['Rating_penitip'] != null ? (json['Rating_penitip'] as num).toDouble() : null,
      fotoKtp: json['foto_ktp'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id_penitip': idPenitip,
      'nama_penitip': namaPenitip,
      'nomor_ktp': nomorKtp,
      'email_penitip': emailPenitip,
      'tanggal_lahir': tanggalLahir,
      'password_penitip': passwordPenitip,
      'nomor_telepon_penitip': nomorTeleponPenitip,
      'saldo_penitip': saldoPenitip,
      'total_poin': totalPoin,
      'badge': badge,
      'jumlah_penjualan': jumlahPenjualan,
      'foto_profil': fotoProfil,
      'Rating_penitip': ratingPenitip,
      'foto_ktp': fotoKtp,
    };
  }
}
