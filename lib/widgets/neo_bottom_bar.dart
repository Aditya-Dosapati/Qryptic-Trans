import 'package:flutter/material.dart';

class NeoBottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const NeoBottomBar({required this.index, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 6), // Removed bottom margin
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
          height: 52, // keep fixed height
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
    final bool active = i == index;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (i == index) return;
        String route = '/';
        if (i == 0) route = '/home';
        if (i == 1) route = '/search';
        if (i == 2) route = '/alerts';
        if (i == 3) route = '/feedback';
        Navigator.of(context).pushReplacementNamed(route);
      },
      child: SizedBox(
        height: 40, // 👈 keeps icon + text inside without overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center, // vertically center
          children: [
            Icon(
              icon,
              color: active ? Colors.white : Colors.white70,
              size: 20, // 👈 smaller size
            ),
            const SizedBox(height: 2), // less spacing
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.white70,
                fontSize: 10, // 👈 smaller font
              ),
            ),
          ],
        ),
      ),
    );
  }
}
