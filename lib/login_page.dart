import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'email_register_page.dart';
import 'registration_page.dart';
import 'home_page.dart';
import 'widgets/login_bottom_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Phone
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  String? _verificationId;
  bool _otpSent = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  // After any successful sign‑in, route based on Firestore profile
  Future<void> _routeAfterSignIn(User user) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!mounted) return;
    if (doc.exists) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (_) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RegistrationPage(user: user)),
        (_) => false,
      );
    }
  }

  // ===== Phone Auth =====
  Future<void> _sendOtp() async {
    final raw = _phoneCtrl.text.trim();
    if (raw.length != 10 || int.tryParse(raw) == null) {
      _snack('Enter a valid 10-digit phone number');
      return;
    }
    final phone = '+91$raw';
    setState(() => _busy = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final cred = await FirebaseAuth.instance.signInWithCredential(
            credential,
          );
          if (cred.user != null) await _routeAfterSignIn(cred.user!);
        } catch (_) {
          /* allow manual entry */
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        _snack('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _otpSent = true; // show OTP field (old‑style same page)
        });
        _snack('OTP sent. Check your phone.');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
    setState(() => _busy = false);
  }

  Future<void> _verifyOtp() async {
    if (_verificationId == null) return _snack('Send OTP first');
    setState(() => _busy = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpCtrl.text.trim(),
      );
      final userCred = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      if (userCred.user != null) await _routeAfterSignIn(userCred.user!);
    } catch (e) {
      _snack('OTP verify failed: $e');
    }
    setState(() => _busy = false);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Phone')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ===== Phone Tab Only =====
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 25),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('+91', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          labelText: 'Phone number',
                          hintText: 'XXXXXXXXXX',
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                if (_otpSent)
                  TextField(
                    controller: _otpCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Enter OTP'),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _busy ? null : _sendOtp,
                        child: _busy
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Send OTP'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _busy ? null : _verifyOtp,
                        child: const Text('Verify OTP'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: LoginBottomBar(),
    );
  }
}
