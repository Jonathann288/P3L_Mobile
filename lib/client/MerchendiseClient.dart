import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_reusemart/entity/Merchendise.dart';

class MerchendiseClient {
  static const String url = '10.0.2.2';

  static Future<List<Merchandise>> fetchMerchandise() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Ambil token dari SharedPreferences

    final uri = Uri.http(url, '/P3L/public/api/auth/merchandise');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    print('Token: $token');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        List<dynamic> list = data['data'];
        return list.map((item) => Merchandise.fromJson(item)).toList();
      } else {
        throw Exception('Gagal ambil data merchandise');
      }
    } else {
      throw Exception('Terjadi kesalahan saat koneksi: ${response.statusCode}');
    }
  }

}