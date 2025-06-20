import 'package:flutter_application_reusemart/entity/Penitip.dart';

class TopSellerDetails {
  final Penitip penitip;
  final int totalTransaksi;
  final double totalPenjualanValue;
  final String monthName; // [TAMBAHAN] Untuk menyimpan nama bulan

  TopSellerDetails({
    required this.penitip,
    required this.totalTransaksi,
    required this.totalPenjualanValue,
    required this.monthName,
  });

  factory TopSellerDetails.fromJson(Map<String, dynamic> json) {
    return TopSellerDetails(
      penitip: Penitip.fromJson(json),
      totalTransaksi: int.tryParse(json['total_transaksi'].toString()) ?? 0,
      totalPenjualanValue: double.tryParse(json['total_penjualan_value'].toString()) ?? 0.0,
      monthName: json['month_name'] ?? 'Periode Tidak Diketahui',
    );
  }
}

class TopSellerData {
  final Penitip? currentMonthTopSeller;
  // [PERUBAHAN] Menggunakan List untuk menyimpan banyak pemenang
  final List<TopSellerDetails> historicalWinners;

  TopSellerData({
    this.currentMonthTopSeller,
    required this.historicalWinners,
  });

  factory TopSellerData.fromJson(Map<String, dynamic> json) {
    var winnersList = json['historical_winners'] as List? ?? [];
    List<TopSellerDetails> winners = winnersList.map((i) => TopSellerDetails.fromJson(i)).toList();
    
    return TopSellerData(
      currentMonthTopSeller: json['current_month_topseller'] != null
          ? Penitip.fromJson(json['current_month_topseller'])
          : null,
      historicalWinners: winners,
    );
  }
}