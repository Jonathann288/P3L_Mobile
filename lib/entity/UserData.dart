import 'package:flutter_application_reusemart/entity/Pegawai.dart';
import 'package:flutter_application_reusemart/entity/Pembeli.dart';
import 'package:flutter_application_reusemart/entity/Penitip.dart';
class UserData {
  final dynamic user;
  final String role;

  UserData({
    required this.user,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    final role = json['role'] as String? ?? '';

    dynamic user;
    switch (role) {
      case 'pegawai':
        user = Pegawai.fromJson(json['user']);
        break;
      case 'penitip':
        user = Penitip.fromJson(json['user']);
        break;
      case 'pembeli':
        user = Pembeli.fromJson(json['user']);
        break;
      default:
        user = json['user']; // fallback raw map
    }

    return UserData(
      user: user,
      role: role,
    );
  }
}