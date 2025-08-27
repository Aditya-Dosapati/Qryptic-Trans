import 'package:flutter/material.dart';
import '../pages/notifications_page.dart';

class LoginBottomBar extends StatelessWidget {
  const LoginBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 18),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, Icons.home_filled, 'Home', 0),
              _navItem(context, Icons.search, 'Search', 1),
              const SizedBox(width: 56), // space for FAB
              _navItem(context, Icons.notifications_active, 'Alerts', 2),
              _navItem(context, Icons.feedback, 'Feedback', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, int i) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (i == 2) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const NotificationsPage()));
        }
        // Add navigation for other tabs as needed
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
