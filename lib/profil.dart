import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/client/AuthClient.dart'; // file dimana ada AuthClient, MeResponse, dll
import 'package:flutter_application_reusemart/entity/Pegawai.dart';
import 'package:flutter_application_reusemart/entity/Pembeli.dart';
import 'package:flutter_application_reusemart/entity/Penitip.dart';
import 'package:flutter_application_reusemart/PegawaiProfile.dart';
import 'package:flutter_application_reusemart/PenitipProfile.dart';
import 'package:flutter_application_reusemart/PembeliProfile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthClient authClient = AuthClient();

  bool isLoading = true;
  String? errorMessage;

  String? role;
  dynamic user;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final meResponse = await authClient.fetchMe();
      setState(() {
        role = meResponse.data.role;
        user = meResponse.data.user;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await authClient
          .logout(); // Asumsikan ada method logout di AuthClient yang menghapus token dll
      // Setelah logout, pindah ke halaman login atau halaman utama
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacementNamed('/login'); // Ganti dengan route login kamu
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout gagal: ${e.toString()}')),
      );
    }
  }

  Widget _buildProfile() {
    if (user == null || role == null) {
      return const Text('Tidak ada data profil');
    }

    switch (role) {
      case 'pegawai':
        return PegawaiProfile(pegawai: user as Pegawai);
      case 'penitip':
        return PenitipProfile(penitip: user as Penitip);
      case 'pembeli':
        return PembeliProfile(pembeli: user as Pembeli);
      default:
        return Text('Role tidak dikenal: $role');
    }
  }

  final TextStyle _titleStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      //...
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Error: $errorMessage'))
              : _buildProfile(),
//...
    );
  }
}
