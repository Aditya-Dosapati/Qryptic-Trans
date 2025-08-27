import 'package:flutter/material.dart';

class ViewAllPage extends StatelessWidget {
  const ViewAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      'Bill Payments',
      'Recharge',
      'Book Flights',
      'Investments',
      'Mutual Funds',
      'Fixed Deposits',
      'Donations',
      'Gaming',
      'Subscriptions',
      'Gift Cards',
      'Rent',
      'Split Bills',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('All Features')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.apps),
          title: Text(items[i]),
          trailing: const Icon(Icons.chevron_right),
        ),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: items.length,
      ),
    );
  }
}
