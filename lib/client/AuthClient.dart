import 'dart:convert';
import 'package:flutter_application_reusemart/entity/Pegawai.dart';
import 'package:flutter_application_reusemart/entity/Pembeli.dart';
import 'package:flutter_application_reusemart/entity/Penitip.dart';
import 'package:flutter_application_reusemart/entity/MeResponse.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthClient {
  static const String url = '192.168.1.46'; // pakai http dan port Laravel

  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.http(url, 'P3L/public/api/auth/login'); // gunakan parse, bukan http()
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('role', data['role']);
      await prefs.setString('user', jsonEncode(data['user']));
      return data;
    } else {
      throw Exception(data['message'] ?? 'Login failed');
    }
  }

  Future<MeResponse> fetchMe() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan, silahkan login ulang');
    }

    final uri = Uri.http(url, '/P3L/public/api/auth/me'); // sesuaikan endpoint

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return MeResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mendapatkan data profil');
    }
  }


  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;

    final uri = Uri.http(url, '/P3L/public/api/auth/logout');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await prefs.remove('token');
      await prefs.remove('role');
      await prefs.remove('user');
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}
