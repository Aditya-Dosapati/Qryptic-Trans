import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

// Custom color palette
class AppColors {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color accentViolet = Color(0xFF8E24AA);
  static const Color softLavender = Color(0xFFE1BEE7);
  static const Color textDark = Color.fromARGB(255, 255, 255, 255);
  static const Color textLight = Color(0xFF757575);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
}

class CheckBalancePage extends StatefulWidget {
  const CheckBalancePage({super.key});

  @override
  State<CheckBalancePage> createState() => _CheckBalancePageState();
}

class _CheckBalancePageState extends State<CheckBalancePage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isGeneratingOtp = false;
  bool _isVerifyingOtp = false;
  String? _selectedBank;

  // Flask server URL - Android emulator uses 10.0.2.2 to access host localhost
  static const String _serverUrl = 'http://10.0.2.2:5001';

  Future<void> _generateOtp() async {
    setState(() => _isGeneratingOtp = true);

    try {
      print('🔗 Attempting to connect to $_serverUrl/generate-otp');

      final response = await http
          .get(
            Uri.parse('$_serverUrl/generate-otp'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print('📱 Response status: ${response.statusCode}');
      print('📱 Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ OTP generated successfully!');
        _showOtpDialog();
      } else {
        print('❌ Failed to generate OTP: ${response.statusCode}');
        _showErrorDialog(
          'Failed to generate OTP. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('🚨 Connection error: $e');
      _showErrorDialog(
        'Connection Error: $e\n\nTroubleshooting:\n1. Make sure Flask server is running\n2. Check if using Android emulator\n3. Try restarting the Flask server',
      );
    } finally {
      setState(() => _isGeneratingOtp = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length != 4) {
      // Don't close dialog, just show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 4-digit OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isVerifyingOtp = true);

    try {
      print('🔐 Verifying OTP: ${_otpController.text.trim()}');

      final response = await http
          .post(
            Uri.parse('$_serverUrl/verify-otp'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'otp': _otpController.text.trim()}),
          )
          .timeout(const Duration(seconds: 10));

      print('📱 Verify response status: ${response.statusCode}');
      print('📱 Verify response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        print('✅ OTP verified successfully!');
        Navigator.pop(context); // Close OTP dialog
        _showBalanceDialog();
      } else {
        print('❌ OTP verification failed');
        // Don't close dialog, just show error and clear the field
        _otpController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? 'Invalid OTP. Please try again.',
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Generate New OTP',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context); // Close current OTP dialog
                _generateOtp(); // Generate new OTP
              },
            ),
          ),
        );
      }
    } catch (e) {
      print('🚨 Verification error: $e');
      // Don't close dialog, just show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isVerifyingOtp = false);
    }
  }

  void _showOtpDialog() {
    _otpController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Enter OTP for $_selectedBank'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Check your Flask server terminal for the generated OTP',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    enabled: !_isVerifyingOtp,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) {
                      // Rebuild dialog to update the Verify button enabled state
                      setDialogState(() {});
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter 4-digit OTP',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wrong OTP? Try again or generate a new one',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: _isVerifyingOtp
                      ? null
                      : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: _isVerifyingOtp
                      ? null
                      : () {
                          Navigator.pop(context); // Close current dialog
                          _generateOtp(); // Generate new OTP
                        },
                  child: const Text('New OTP'),
                ),
                ElevatedButton(
                  onPressed:
                      _isVerifyingOtp || _otpController.text.trim().length != 4
                      ? null
                      : () async {
                          // Kick off verification and force dialog rebuilds
                          final future = _verifyOtp();
                          setDialogState(
                            () {},
                          ); // reflect loading state quickly
                          await future; // wait for verification to complete
                          if (mounted)
                            setDialogState(() {}); // refresh dialog state
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentViolet,
                  ),
                  child: _isVerifyingOtp
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Verify OTP',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBalanceDialog() {
    // Simulate different balances for different banks
    final balances = {
      'State Bank of India': '₹1,25,480.75',
      'HDFC Bank': '₹89,320.50',
      'ICICI Bank': '₹2,15,750.25',
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$_selectedBank Balance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 48,
                color: AppColors.accentViolet,
              ),
              const SizedBox(height: 16),
              Text(
                'Available Balance',
                style: TextStyle(fontSize: 16, color: AppColors.textLight),
              ),
              const SizedBox(height: 8),
              Text(
                balances[_selectedBank] ?? '₹0.00',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Last updated: ${DateTime.now().toString().substring(0, 16)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentViolet,
              ),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _selectBank(String bankName) {
    setState(() => _selectedBank = bankName);
    _generateOtp();
  }

  Widget _buildBankItem(String bankName, IconData icon) {
    return InkWell(
      onTap: _isGeneratingOtp ? null : () => _selectBank(bankName),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: AppColors.accentViolet),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    bankName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (_isGeneratingOtp && _selectedBank == bankName)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
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
          'Check Balance',
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
          _buildBankItem('State Bank of India', Icons.account_balance),
          _buildBankItem('HDFC Bank', Icons.credit_card),
          _buildBankItem('ICICI Bank', Icons.business),
        ],
      ),
    );
  }
}
