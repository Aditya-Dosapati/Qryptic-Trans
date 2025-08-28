import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/otp_service.dart';
import '../db/user_database.dart' as localdb;

class ToMobilePage extends StatefulWidget {
  final int userId;
  const ToMobilePage({super.key, required this.userId});

  @override
  State<ToMobilePage> createState() => _ToMobilePageState();
}

class _ToMobilePageState extends State<ToMobilePage> {
  final _mobileCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _confirmAndOtp(String mobile, double amount) async {
    // Optional final confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Transfer'),
        content: Text('Send ₹${amount.toStringAsFixed(2)} to $mobile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await OtpService.showOtpFlow(
      context: context,
      title: 'Verify To Mobile',
      onVerified: () async {
        final user = await localdb.UserDatabase.instance.readUser(
          widget.userId,
        );
        if (user == null) {
          _snack('User not found');
          return;
        }
        final updated = user.copyWith(balance: user.balance - amount);
        await localdb.UserDatabase.instance.update(updated);
        if (!mounted) return;
        _snack('Money sent to $mobile');
        Navigator.of(context).pop(true);
      },
    );
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send To Mobile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _mobileCtrl,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone_android),
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.length != 10)
                    ? 'Enter valid 10-digit mobile'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                validator: (v) {
                  final x = double.tryParse(v ?? '');
                  if (x == null || x <= 0) return 'Enter valid amount';
                  return null;
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 201, 105, 218),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    final mob = _mobileCtrl.text.trim();
                    final amt = double.tryParse(_amountCtrl.text.trim())!;
                    _confirmAndOtp(mob, amt);
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
