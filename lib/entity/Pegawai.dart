import 'package:flutter_application_reusemart/entity/Jabatan.dart';
class Pegawai {
  final int? idPegawai;
  final String? namaPegawai;
  final String? tanggalLahirPegawai;
  final String? nomorTeleponPegawai;
  final String? emailPegawai;
  final String? passwordPegawai;
  final int? idJabatan;
  final Jabatan? jabatan;

  Pegawai({
    this.idPegawai,
    this.namaPegawai,
    this.tanggalLahirPegawai,
    this.nomorTeleponPegawai,
    this.emailPegawai,
    this.passwordPegawai,
    this.idJabatan,
    this.jabatan,
  });

  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      idPegawai: parseInt(json['id_pegawai'] ?? json['id']),
      namaPegawai: json['nama_pegawai'],
      tanggalLahirPegawai: json['tanggal_lahir_pegawai'],
      nomorTeleponPegawai: json['nomor_telepon_pegawai'],
      emailPegawai: json['email_pegawai'],
      passwordPegawai: json['password_pegawai'],
      idJabatan: parseInt(json['id_jabatan']),
      jabatan: json['jabatan'] != null ? Jabatan.fromJson(json['jabatan']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pegawai': idPegawai,
      'nama_pegawai': namaPegawai,
      'tanggal_lahir_pegawai': tanggalLahirPegawai,
      'nomor_telepon_pegawai': nomorTeleponPegawai,
      'email_pegawai': emailPegawai,
      'password_pegawai': passwordPegawai,
      'id_jabatan': idJabatan,
      'jabatan': jabatan?.toJson(),
    };
  }
}