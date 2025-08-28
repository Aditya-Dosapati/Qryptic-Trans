import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpService {
  // Emulator: http://10.0.2.2:5001
  // Physical device: http://<YOUR_PC_IP>:5001
  static const String _serverUrl = 'http://10.0.2.2:5001';

  static Future<bool> showOtpFlow({
    required BuildContext context,
    required String title,
    required Future<void> Function() onVerified,
  }) async {
    try {
      // Step 1: Generate OTP
      final gen = await http
          .get(Uri.parse('$_serverUrl/generate-otp'))
          .timeout(const Duration(seconds: 10));
      if (gen.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate OTP (${gen.statusCode})'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }

      final hint = () {
        try {
          final data = jsonDecode(gen.body);
          return (data is Map && data['hint'] is String)
              ? data['hint'] as String
              : '';
        } catch (_) {
          return '';
        }
      }();

      // Step 2: Ask user for OTP
      final otp = await _promptForOtp(
        context: context,
        title: title,
        hint: hint,
      );
      if (otp == null) return false; // cancelled

      // Step 3: Verify
      final verify = await http
          .post(
            Uri.parse('$_serverUrl/verify-otp'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'otp': otp}),
          )
          .timeout(const Duration(seconds: 10));

      if (verify.statusCode == 200) {
        await onVerified();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction approved'),
            backgroundColor: Colors.green,
          ),
        );
        return true;
      } else {
        final msg = () {
          try {
            final d = jsonDecode(verify.body);
            return (d is Map && d['message'] is String)
                ? d['message'] as String
                : 'Invalid OTP';
          } catch (_) {
            return 'Invalid OTP';
          }
        }();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  static Future<String?> _promptForOtp({
    required BuildContext context,
    required String title,
    String hint = '',
  }) async {
    final controller = TextEditingController();
    bool verifying = false;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter the 4-digit OTP shown in your Flask server terminal.',
                    textAlign: TextAlign.center,
                  ),
                  if (hint.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Hint: $hint',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    enabled: !verifying,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: '4-digit OTP',
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: verifying ? null : () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: verifying || controller.text.trim().length != 4
                      ? null
                      : () {
                          setState(() => verifying = true);
                          // Return the OTP to caller; actual verification happens outside
                          Navigator.pop(ctx, controller.text.trim());
                        },
                  child: verifying
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Verify'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
