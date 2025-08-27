import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'db/user_database.dart' as qisUserDb;
import 'login_page.dart';
import 'registration_page.dart';
import 'home_page.dart';
import 'pages/search_page.dart';
import 'pages/alerts_page.dart';
import 'pages/feedback_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Seed 5 users in local DB if not present
  await qisUserDb.UserDatabase.instance.seedUsers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF2E2A72),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3A0CA3),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF6A11CB),
          secondary: Color(0xFF7209B7),
          background: Color(0xFF2E2A72),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const _AuthGate(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
        '/alerts': (context) => const AlertsPage(),
        '/feedback': (context) => const FeedbackPage(),
      },
    );
  }
}

// Listens to auth state and routes to Login / Home / Registration (for phone first‑timers)
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        final user = snap.data;
        if (snap.connectionState != ConnectionState.active) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (user == null) return const LoginPage();

        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, docSnap) {
            if (docSnap.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (docSnap.hasData && docSnap.data!.exists) {
              return const HomePage();
            }
            // Phone users land here first time to complete profile
            return RegistrationPage(user: user);
          },
        );
      },
    );
  }
}

// http://localhost:5000/generate-otp
