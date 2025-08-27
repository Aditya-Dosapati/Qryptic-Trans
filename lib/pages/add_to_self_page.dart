import 'package:flutter/material.dart';
import '../db/user_database.dart' as localdb;

// Custom color palette
class AppColors {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color accentViolet = Color(0xFF8E24AA);
  static const Color softLavender = Color(0xFFE1BEE7);
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
}

class AddToSelfPage extends StatefulWidget {
  final int userId;
  const AddToSelfPage({super.key, required this.userId});

  @override
  State<AddToSelfPage> createState() => _AddToSelfPageState();
}

class _AddToSelfPageState extends State<AddToSelfPage> {
  final _amountCtrl = TextEditingController();

  Future<void> _addToSelf() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      _snack('Enter a valid amount');
      return;
    }
    final user = await localdb.UserDatabase.instance.readUser(widget.userId);
    if (user == null) {
      _snack('User not found');
      return;
    }
    // For demo, treat "to self" as adding to wallet
    final updated = user.copyWith(balance: user.balance + amount);
    await localdb.UserDatabase.instance.update(updated);
    _snack('Added to self wallet!');
    Navigator.of(context).pop(true);
  }

  void _showInputDialog(BuildContext context, String walletType) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add to $walletType'),
          content: TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter amount (e.g. 1000)',
              prefixText: '₹ ',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.pop(context);
                _addToSelf();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildWalletItem(String walletName, IconData icon) {
    return InkWell(
      onTap: () => _showInputDialog(context, walletName),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: AppColors.accentViolet),
                const SizedBox(width: 12),
                Text(
                  walletName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // removes hard shadow
        centerTitle: true,
        backgroundColor: Colors.transparent, // for gradient background
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6C63FF), // soft purple
                Color(0xFF8E24AA), // light bluish purple
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Add to Self',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // maybe show help or info
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20), // rounded bottom for smooth look
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildWalletItem('Primary Wallet', Icons.account_balance_wallet),
          _buildWalletItem('Savings Wallet', Icons.savings),
          _buildWalletItem('Investment Wallet', Icons.trending_up),
        ],
      ),
    );
  }
}
