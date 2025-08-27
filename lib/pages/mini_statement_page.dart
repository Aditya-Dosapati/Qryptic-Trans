import 'package:flutter/material.dart';
import '../db/user_database.dart';

class MiniStatementPage extends StatelessWidget {
  final int userId;
  const MiniStatementPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Statement')),
      body: FutureBuilder<User?>(
        future: UserDatabase.instance.readUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('No user found.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Name: ${user.name}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                'Balance: ₹${user.balance.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
              // Add transaction list here if available
            ],
          );
        },
      ),
    );
  }
}
