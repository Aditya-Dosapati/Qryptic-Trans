import 'package:flutter/material.dart';
import '../db/user_database.dart' as localdb;

class AddToSelfPage extends StatefulWidget {
  final int userId;
  const AddToSelfPage({super.key, required this.userId});

  @override
  State<AddToSelfPage> createState() => _AddToSelfPageState();
}

class _AddToSelfPageState extends State<AddToSelfPage> {
  final _amountCtrl = TextEditingController();
  bool _busy = false;

  Future<void> _addToSelf() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      _snack('Enter a valid amount');
      return;
    }
    setState(() => _busy = true);
    final user = await localdb.UserDatabase.instance.readUser(widget.userId);
    if (user == null) {
      _snack('User not found');
      setState(() => _busy = false);
      return;
    }
    // For demo, treat "to self" as adding to wallet
    final updated = user.copyWith(balance: user.balance + amount);
    await localdb.UserDatabase.instance.update(updated);
    _snack('Added to self wallet!');
    setState(() => _busy = false);
    Navigator.of(context).pop(true);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add to Self Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _busy ? null : _addToSelf,
              child: _busy
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add to Self'),
            ),
          ],
        ),
      ),
    );
  }
}
