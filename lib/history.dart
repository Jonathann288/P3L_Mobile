import 'package:flutter/material.dart';
import 'package:flutter_application_reusemart/client/AuthClient.dart';
import 'package:flutter_application_reusemart/entity/Pegawai.dart';
import 'package:flutter_application_reusemart/historyHunter.dart';
import 'package:flutter_application_reusemart/historyPegawai.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => HistoryScreenPage();
}

class HistoryScreenPage extends State<HistoryScreen> {
  final AuthClient authClient = AuthClient();
  final Color blue600 = const Color(0xFF2563EB); // Define the blue color

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
      await authClient.logout();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout gagal: ${e.toString()}')),
      );
    }
  }

  Widget _buildHistory() {
    if (user == null || role == null) {
      return const Text('Tidak ada data history');
    }

    if (role == 'pegawai') {
      final Pegawai pegawai = user as Pegawai;
      final jabatanStr = pegawai.jabatan?.namaJabatan?.toLowerCase() ?? '';

      switch (jabatanStr) {
        case 'hunter':
          return const HistoryHunter();
        case 'kurir':
          return const HistoryPegawaiPage();
        default:
          return Text('Jabatan pegawai tidak dikenal: ${pegawai.jabatan?.namaJabatan}');
      }
    } else {
      return Text('Role tidak dikenal atau tidak punya history: $role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History Saya',
          style: const TextStyle(color: Colors.white),
          ),
        backgroundColor: blue600,
        iconTheme: const IconThemeData(color: Colors.white), // Apply blue color to app bar
      ),
      body: Container( // Apply blue color to background
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text('Error: $errorMessage'))
                  : _buildHistory(),
        ),
      ),
    );
  }
}