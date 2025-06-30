import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_reusemart/entity/Kategori_barang.dart';
import 'package:flutter_application_reusemart/entity/Barang.dart';

class Barangclient {
  static const String url = 'reusemartshop.sikoding.id';

  Future<Map<String, dynamic>> fetchShopData() async {
    final uri = Uri.https('$url', '/api/shop-show');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List<KategoriBarang> kategoris = (data['kategoris'] as List)
          .map((json) => KategoriBarang.fromJson(json))
          .toList();

      List<Barang> barangs = (data['barang'] as List)
          .map((json) => Barang.fromJson(json))
          .toList();

      List<String> images = data['images'].map((e) => e.toString()).toList().cast<String>();

      return {
        'kategoris': kategoris,
        'barang': barangs,
        'images': images,
      };
    } else {
      throw Exception('Gagal mengambil data shop');
    }
  }

  Future<Map<String, dynamic>> fetchBarangDetail(int idBarang) async {
    final uri = Uri.https('$url', '/api/barang/$idBarang');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Parse data barang dari json
      final Barang barang = Barang.fromJson(data['barang']);

      final bool isElektronik = (barang.idKategori == 1);

      return {
        'barang': barang,
        'isElektronik': isElektronik,
      };
    } else {
      throw Exception('Gagal mengambil detail barang: ${response.body}');
    }
  }
}
