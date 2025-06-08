import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/entity/Penitip.dart';

class PenitipProfile extends StatelessWidget {
  final Penitip penitip;
  final Color primaryColor = Colors.blue; // Customize with your app's theme

  const PenitipProfile({Key? key, required this.penitip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                // Profile Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor,
                    border: Border.all(color: primaryColor, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      penitip.namaPenitip?.substring(0, 1) ?? "?",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Name and Rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        penitip.namaPenitip ?? "-",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            penitip.ratingPenitip?.toStringAsFixed(1) ?? "0.0",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (penitip.badge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                penitip.badge!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Profile Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow(
                  icon: Icons.credit_card,
                  label: "No. KTP",
                  value: penitip.nomorKtp ?? "-",
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.email,
                  label: "Email",
                  value: penitip.emailPenitip ?? "-",
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.cake,
                  label: "Tanggal Lahir",
                  value: penitip.tanggalLahir ?? "-",
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.account_balance_wallet,
                  label: "Saldo",
                  value: "Rp${penitip.saldoPenitip?.toStringAsFixed(2) ?? "0.00"}",
                  isAmount: true,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.loyalty,
                  label: "Total Poin",
                  value: penitip.totalPoin?.toString() ?? "0",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isAmount = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isAmount ? Colors.green : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}