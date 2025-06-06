import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/client/AuthClient.dart';// file dimana ada AuthClient, MeResponse, dll
import 'package:flutter_application_reusemart/entity/Pegawai.dart';
import 'package:flutter_application_reusemart/entity/Pembeli.dart';
import 'package:flutter_application_reusemart/entity/Penitip.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
      await authClient.logout();  // Asumsikan ada method logout di AuthClient yang menghapus token dll
      // Setelah logout, pindah ke halaman login atau halaman utama
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login'); // Ganti dengan route login kamu
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
        final Pegawai pegawai = user as Pegawai;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${pegawai.namaPegawai ?? "-"}', style: _titleStyle),
            Text('Tanggal Lahir: ${pegawai.tanggalLahirPegawai ?? "-"}'),
            Text('No. Telepon: ${pegawai.nomorTeleponPegawai ?? "-"}'),
            Text('Email: ${pegawai.emailPegawai ?? "-"}'),
            Text('Jabatan: ${pegawai.jabatan?.namaJabatan ?? "-"}'),
          ],
        );

      case 'penitip':
        final Penitip penitip = user as Penitip;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${penitip.namaPenitip ?? "-"}', style: _titleStyle),
            Text('No. KTP: ${penitip.nomorKtp ?? "-"}'),
            Text('Email: ${penitip.emailPenitip ?? "-"}'),
            Text('Tanggal Lahir: ${penitip.tanggalLahir ?? "-"}'),
            Text('Saldo: ${penitip.saldoPenitip?.toStringAsFixed(2) ?? "-"}'),
            Text('Total Poin: ${penitip.totalPoin ?? "-"}'),
            Text('Badge: ${penitip.badge ?? "-"}'),
            Text('Rating: ${penitip.ratingPenitip?.toStringAsFixed(2) ?? "-"}'),
          ],
        );

      case 'pembeli':
        final Pembeli pembeli = user as Pembeli;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${pembeli.namaPembeli ?? "-"}', style: _titleStyle),
            Text('Email: ${pembeli.emailPembeli ?? "-"}'),
            Text('No. Telepon: ${pembeli.nomorTeleponPembeli ?? "-"}'),
          ],
        );

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text('Error: $errorMessage'))
                : _buildProfile(),
      ),
    );
  }
}
