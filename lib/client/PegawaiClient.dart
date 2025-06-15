import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_reusemart/entity/transaksi_penjualan.dart';

class PegawaiClient {
  static const String baseUrl = 'http://172.20.10.3'; //ganti sesuai dengan ip

  Future<List<TransaksiPenjualan>> getHistoryPengantaran() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token from prefs: $token');

    final uri = Uri.parse('$baseUrl/api/auth/transaksipenjualan/diantar-kurir');
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
        return jsonList.map((e) => TransaksiPenjualan.fromJson(e)).toList();
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
    final uri = Uri.parse('$baseUrl/api/auth/transaksipenjualan/$idTransaksi/update-status');

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
