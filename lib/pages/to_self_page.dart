import 'package:flutter/material.dart';

class ToSelfPage extends StatelessWidget {
  const ToSelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfer To Self')),
      body: const Center(child: Text('Select your own accounts & transfer')),
    );
  }
}
