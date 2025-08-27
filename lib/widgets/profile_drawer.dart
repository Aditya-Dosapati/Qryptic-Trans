import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../db/user_database.dart' as localdb;
// TODO: Replace static profile details with the first user in Hive box (e.g., box.getAt(0)).
// Display name, email, and role dynamically instead of hardcoding.

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

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
            // 🔹 Profile Header
            FutureBuilder<List<localdb.User>>(
              future: localdb.UserDatabase.instance.readAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: Colors.transparent),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.deepPurple),
                    ),
                    accountName: Text("No User"),
                    accountEmail: Text(""),
                  );
                }
                final user = snapshot.data!.first;
                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  accountName: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    user.gender,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              },
            ),

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
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.redAccent),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
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
