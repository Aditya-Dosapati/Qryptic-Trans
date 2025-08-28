import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../db/user_database.dart' as localdb;

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  // Cache user data to prevent repeated database calls
  localdb.User? _cachedUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    if (_cachedUser == null) {
      try {
        _cachedUser = await localdb.UserDatabase.instance.readOrSeedFirstUser();
      } catch (e) {
        debugPrint('Error loading user: $e');
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildProfileHeader() {
    if (_isLoading) {
      return const UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Colors.transparent),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, color: Colors.deepPurple),
        ),
        accountName: Text("Loading..."),
        accountEmail: Text(""),
      );
    }

    final user = _cachedUser;
    if (user == null) {
      return const UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Colors.transparent),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(Icons.warning, color: Colors.white),
        ),
        accountName: Text("Fallback User"),
        accountEmail: Text("Please restart app"),
      );
    }

    final String avatarImg =
        user.gender.toLowerCase() == 'm' || user.gender.toLowerCase() == 'male'
        ? 'assets/images/male.jpg'
        : 'assets/images/female.jpg';

    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: Colors.transparent),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage(avatarImg),
        onBackgroundImageError: (_, __) {},
        child: Text(user.name.substring(0, 1).toUpperCase()),
      ),
      accountName: Text(
        user.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(user.phone, style: const TextStyle(fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75, // 75% width
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A0CA3), Color(0xFF7209B7)], // retro purple
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Profile Header - Now cached for better performance
            _buildProfileHeader(),

            // 🔹 Menu Items
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                "Settings",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                // Add navigation here
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.white),
              title: const Text(
                "History",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                // Add navigation here
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text("About", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                // Add navigation here
              },
            ),

            const Spacer(),

            // 🔹 Logout Button
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              title: const Text(
                "Logout",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 243, 121, 216),
            ),
            onPressed: () async {
              Navigator.of(context).pop(); // close dialog
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out successfully")),
                );
                Navigator.pushReplacementNamed(context, "/login");
              }
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
