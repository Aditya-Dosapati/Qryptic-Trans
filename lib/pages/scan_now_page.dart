import 'package:flutter/material.dart';

class ScanNowPage extends StatelessWidget {
  const ScanNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Now')),
      body: const Center(child: Icon(Icons.qr_code_scanner, size: 120)),
    );
  }
}
