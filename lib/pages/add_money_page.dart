import 'package:flutter/material.dart';
import '../db/user_database.dart' as localdb;
import '../services/otp_service.dart';

class AddMoneyPage extends StatefulWidget {
  final int userId;
  const AddMoneyPage({super.key, required this.userId});

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  final _amountCtrl = TextEditingController();
  bool _busy = false;

  Future<void> _addMoney() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      _snack('Enter a valid amount');
      return;
    }
    // OTP verification before applying the credit
    await OtpService.showOtpFlow(
      context: context,
      title: 'Verify Add Money',
      onVerified: () async {
        setState(() => _busy = true);
        final user = await localdb.UserDatabase.instance.readUser(
          widget.userId,
        );
        if (user == null) {
          _snack('User not found');
          setState(() => _busy = false);
          return;
        }
        final updated = user.copyWith(balance: user.balance + amount);
        await localdb.UserDatabase.instance.update(updated);
        _snack('Money added successfully!');
        setState(() => _busy = false);
        if (!mounted) return;
        Navigator.of(context).pop(true);
      },
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Money to Wallet')),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 221, 94, 215),
                foregroundColor: Colors.white,
              ),
              onPressed: _busy ? null : _addMoney,
              child: _busy
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add Money'),
            ),
          ],
        ),
      ),
    );
  }
}
