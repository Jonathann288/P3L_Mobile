// lib/client/transaksipenitipan_client.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// Import diubah ke file yang baru
import 'package:flutter_application_reusemart/entity/transaksipenitipan.dart';

// Nama class diubah menjadi TransaksiPenitipanClient
class TransaksiPenitipanClient {
  static const String url = '172.20.10.5'; // Sesuaikan dengan IP Anda

  // Tipe data return diubah menjadi TransaksiPenitipanHistory
  static Future<List<TransaksiPenitipanHistory>> fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token tidak ditemukan, silahkan login ulang');
    }

    final uri = Uri.http(url, '/P3L/public/api/penitip/history');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (kDebugMode) {
      print('===== HISTORY PENITIP RESPONSE =====');
      print(response.body);
      print('====================================');
    }

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        List<dynamic> listData = data['data'];
        // Parsing diubah menggunakan class yang baru
        return listData.map((item) => TransaksiPenitipanHistory.fromJson(item)).toList();
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Gagal mengambil data riwayat');
    }
  }
}