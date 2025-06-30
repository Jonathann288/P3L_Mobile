// File: lib/client/transaksi_client.dart
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Import ini untuk kDebugMode
import 'package:flutter_application_reusemart/entity/TransaksiPenjualan2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransaksiClient {
  static const String url = 'reusemartshop.sikoding.id';

  static Future<List<TransaksiPenjualan2>> fetchHistory(String? startDate, String? endDate) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Token tidak ditemukan');

    Map<String, String> queryParams = {
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    };

    final uri = Uri.https(url, '/api/auth/pembeli/history', queryParams);
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    final data = jsonDecode(response.body);

    // ===================================================================
    // TAMBAHKAN PRINT DI SINI UNTUK MELIHAT DATA MENTAH DARI SERVER
    if (kDebugMode) {
      // Menggunakan jsonEncode agar formatnya rapi dan bisa di-copy
      print("===== RAW JSON RESPONSE FROM API =====");
      print(jsonEncode(data));
      print("======================================");
    }
    // ===================================================================

    if (response.statusCode == 200 && data['success'] == true) {
      List<dynamic> listData = data['data'];
      return listData.map((item) => TransaksiPenjualan2.fromJson(item)).toList();
    } else {
      throw Exception(data['message'] ?? 'Gagal mengambil data riwayat');
    }
  }
}