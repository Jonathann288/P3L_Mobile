import 'dart:convert';
import 'package:flutter/foundation.dart'; // Diperlukan untuk kDebugMode
import 'package:flutter_application_reusemart/entity/topseller_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TopSellerClient {
  static const String url = '10.0.2.2'; // Pastikan IP ini sudah benar

  static Future<TopSellerData> fetchTopSellers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token tidak ditemukan, silahkan login ulang');
    }

    final uri = Uri.http(url, '/P3L/public/api/auth/topseller');
    
    // -- DEBUGGING --
    if (kDebugMode) {
      print('==== MEMANGGIL API TOPSLELLER ====');
      print('URL: $uri');
      print('Token: $token');
    }
    // -- AKHIR DEBUGGING --

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    // -- DEBUGGING --
    // Mencetak status code dan body mentah dari respons server.
    // Ini adalah bagian terpenting untuk debugging.
    if (kDebugMode) {
      print('==== RESPON DARI SERVER ====');
      print('Status Code: ${response.statusCode}');
      print('Body:');
      // Menggunakan JsonEncoder untuk merapikan format JSON agar mudah dibaca
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(json.decode(response.body));
      print(prettyprint);
      print('=============================');
    }
    // -- AKHIR DEBUGGING --

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return TopSellerData.fromJson(data['data']);
      } else {
        // Jika server merespons dengan 'success': false
        throw Exception(data['message'] ?? 'Server mengembalikan respons gagal');
      }
    } else {
      // Jika status code bukan 200 (misal: 500 Internal Server Error, 404 Not Found, dll)
      throw Exception('Gagal mengambil data top seller. Status: ${response.statusCode}');
    }
  }
}