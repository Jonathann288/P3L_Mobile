import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PegawaiClient {
  static const String url = '10.0.2.2';

  Future<Map<String, dynamic>> getKomisiHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token from prefs: $token');

    final uri = Uri.http('$url','/P3L/public/api/auth/komisi/history');
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

}