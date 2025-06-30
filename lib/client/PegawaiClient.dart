import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_reusemart/entity/transaksi_penjualan.dart';
import 'package:flutter_application_reusemart/entity/TransaksiPenitipan.dart';

class PegawaiClient {
  static const String url = 'reusemartshop.sikoding.id';

  Future<Map<String, dynamic>> getKomisiHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token from prefs: $token');

    final uri = Uri.https('$url','/api/auth/komisi/history');
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // Laravel response: { "data": [ {...}, {...}, ... ] }
      return jsonResponse['data'];

    } else if (response.statusCode == 403) {
      throw Exception('Unauthorized: Akses ditolak');
    } else {
      throw Exception('Gagal memuat data komisi, status code: ${response.statusCode}');
    }
  }

  Future<List<TransaksiPenjualan3>> getHistoryPengantaran() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token from prefs: $token');

    final uri = Uri.https('$url','/api/auth/transaksipenjualan/diantar-kurir');
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        List<dynamic> jsonList = data['data'];
        return jsonList.map((e) => TransaksiPenjualan3.fromJson(e)).toList();
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Gagal memuat data riwayat pengantaran');
    }
  }

  Future<bool> updateStatusTransaksi(
    String idTransaksi, String statusBaru) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.https('$url','/api/auth/transaksipenjualan/$idTransaksi/update-status');

    final response = await http.put(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status_transaksi': statusBaru}),
    );

    return response.statusCode == 200 &&
        jsonDecode(response.body)['success'] == true;
  }
}