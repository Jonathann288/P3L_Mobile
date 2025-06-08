class TransaksiPenjualan {
  final String? metodePengantaran; // Field untuk metode pengantaran


  TransaksiPenjualan({
    this.metodePengantaran,

  });

  factory TransaksiPenjualan.fromJson(Map<String, dynamic> json) {
    return TransaksiPenjualan(
      metodePengantaran: json['metode_pengantaran'], // Parsing metode pengantaran
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metode_pengantaran': metodePengantaran, // Metode pengantaran
    };
  }
}