import 'package:flutter/material.dart';
import '../data/local_db.dart';
import '../models/user_model.dart';

class MiniStatementPage extends StatelessWidget {
  final int userId;
  const MiniStatementPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final user = LocalDB.users.firstWhere(
      (u) => u.id == userId,
      orElse: () =>
          UserModel(id: 0, name: "Unknown", balance: 0, transactions: []),
    );

    final transactions = user.transactions;

    return Scaffold(
      appBar: AppBar(title: Text('${user.name} - Mini Statement')),
      body: transactions.isEmpty
          ? const Center(child: Text("No transactions found."))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final tx =
                    transactions[transactions.length - 1 - i]; // latest first
                return ListTile(
                  leading: Icon(
                    tx.amount < 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: tx.amount < 0 ? Colors.redAccent : Colors.green,
                  ),
                  title: Text(tx.description),
                  subtitle: Text(
                    tx.date.toLocal().toString().split(" ")[0],
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
                    (tx.amount < 0 ? "-" : "+") +
                        "₹${tx.amount.abs().toStringAsFixed(2)}",
                    style: TextStyle(
                      color: tx.amount < 0 ? Colors.redAccent : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
