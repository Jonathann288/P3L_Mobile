import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/entity/Pembeli.dart';

class PembeliProfile extends StatelessWidget {
  final Pembeli pembeli;
  final Color primaryColor = Colors.deepPurple;
  final Color secondaryColor = Colors.deepPurple;

  const PembeliProfile({Key? key, required this.pembeli}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, secondaryColor.withOpacity(0.1)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Profile Avatar with decorative border
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    pembeli.namaPembeli?.substring(0, 1).toUpperCase() ?? "?",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Profile Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pembeli.namaPembeli ?? "-",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow(Icons.email_outlined, pembeli.emailPembeli),
                    const SizedBox(height: 6),
                    _buildInfoRow(Icons.phone_iphone_rounded, pembeli.nomorTeleponPembeli),
                    const SizedBox(height: 8),
                    _buildRatingBadge(),
                  ],
                ),
              ),
              // Action Buttons
              Column(
                children: [
                  _buildActionButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    onPressed: () {
                      // Handle chat action
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.star_border_rounded,
                    onPressed: () {
                      // Handle favorite action
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: primaryColor,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value ?? "-",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            "4.8 (12 reviews)",
            style: TextStyle(
              fontSize: 12,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: primaryColor),
        onPressed: onPressed,
        splashRadius: 24,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        iconSize: 22,
      ),
    );
  }
}