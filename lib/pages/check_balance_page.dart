import 'package:flutter/material.dart';

class CheckBalancePage extends StatelessWidget {
  const CheckBalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check Balance')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            'Your balance is ₹12,480.55',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
