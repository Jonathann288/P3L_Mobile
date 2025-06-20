class ClaimMerchandise {
  final int idTransaksiClaimMerchandise;
  final int idPembeli;
  final int idMerchandise;
  final int? id; // opsional, sesuaikan fungsinya
  final DateTime tanggalClaim;
  final DateTime? tanggalPengambilan;
  final String status;

  ClaimMerchandise({
    required this.idTransaksiClaimMerchandise,
    required this.idPembeli,
    required this.idMerchandise,
    this.id,
    required this.tanggalClaim,
    this.tanggalPengambilan,
    required this.status,
  });

  factory ClaimMerchandise.fromJson(Map<String, dynamic> json) {
    return ClaimMerchandise(
      idTransaksiClaimMerchandise: json['id_transaksi_claim_merchandise'],
      idPembeli: json['id_pembeli'],
      idMerchandise: json['id_merchandise'],
      id: json['id'],
      tanggalClaim: DateTime.parse(json['tanggal_claim']),
      tanggalPengambilan: json['tanggal_pengambilan'] != null
          ? DateTime.parse(json['tanggal_pengambilan'])
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_transaksi_claim_merchandise': idTransaksiClaimMerchandise,
      'id_pembeli': idPembeli,
      'id_merchandise': idMerchandise,
      'id': id,
      'tanggal_claim': tanggalClaim.toIso8601String(),
      'tanggal_pengambilan': tanggalPengambilan?.toIso8601String(),
      'status': status,
    };
  }
}
