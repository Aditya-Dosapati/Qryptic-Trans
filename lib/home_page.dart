import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'pages/notifications_page.dart';
import 'pages/scan_now_page.dart';
import 'pages/to_mobile_page.dart';
import 'pages/add_to_self_page.dart';
import 'pages/check_balance_page.dart';
import 'pages/add_money_page.dart';
import 'pages/view_all_page.dart';
import 'pages/search_page.dart';
import 'pages/alerts_page.dart';
import 'widgets/profile_drawer.dart';
import 'pages/feedback_page.dart';
import 'pages/mini_statement_page.dart';
//import 'data/local_db.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      drawer: ProfileDrawer(),

      // your profile widget
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text("No new notifications")),
              // );
              // OR navigate to NotificationsPage:
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsPage()),
              );
            },
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3E1E68), Color(0xFF2E2A72), Color(0xFF1B1F3B)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                _BalanceHeroCard(
                  onCheckBalance: _openAddMoney,
                  onMiniStatement: _openMiniStatement,
                ),
                const SizedBox(height: 16),
                _QuickActions(
                  onScan: _openScan,
                  onToMobile: _openToMobile,
                  onToSelf: _openToSelf,
                  onCheckBalance: _openCheckBalance,
                  onMiniStatement: _openMiniStatement,
                ),
                const SizedBox(height: 18),
                _FeaturePanel(onViewAll: _openViewAll),
                const SizedBox(height: 18),
                const _InsightsCarousel(),
                const SizedBox(height: 18),
                const _ShortcutsStrip(),
                const SizedBox(height: 18),
                const _RecentActivity(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _NeoBottomBar(
        index: _index,
        onTap: (i) {
          setState(() => _index = i);
          if (i == 1) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SearchPage()));
          } else if (i == 2) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AlertsPage()));
          } else if (i == 3) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const FeedbackPage()));
          }
        },
      ),
      floatingActionButton: _FABScan(onTap: _openScan),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  void _openScan() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => const ScanNowPage()));
  void _openToMobile() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => const ToMobilePage()));
  void _openToSelf() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => AddToSelfPage(userId: 1)));

  void _openAddMoney() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => AddMoneyPage(userId: 1)));
  void _openCheckBalance() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => const CheckBalancePage()));
  void _openViewAll() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => const ViewAllPage()));
  void _openMiniStatement() => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => const MiniStatementPage(userId: 1)));
}

// === Widgets ===
class _BalanceHeroCard extends StatelessWidget {
  final VoidCallback onCheckBalance;
  final VoidCallback onMiniStatement;
  const _BalanceHeroCard({
    required this.onCheckBalance,
    required this.onMiniStatement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF7F53AC), Color(0xFF647DEE)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xAA7F53AC),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Primary Wallet',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 6),
                Text(
                  '₹480.55',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onCheckBalance,
            icon: const Icon(Icons.add, color: Colors.white70, size: 18),
            label: const Text(
              'Add to Wallet',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onScan,
      onToMobile,
      onToSelf,
      onCheckBalance,
      onMiniStatement;
  const _QuickActions({
    required this.onScan,
    required this.onToMobile,
    required this.onToSelf,
    required this.onCheckBalance,
    required this.onMiniStatement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _pill('Mini Statement', Icons.description, onMiniStatement),
        _pill('To Mobile', Icons.send_to_mobile, onToMobile),
        _pill('To Self', Icons.switch_access_shortcut, onToSelf),
        _pill('Balance', Icons.account_balance, onCheckBalance),
      ],
    );
  }

  Widget _pill(String label, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withOpacity(0.09),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturePanel extends StatelessWidget {
  final VoidCallback onViewAll;
  const _FeaturePanel({required this.onViewAll});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quick Panel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(onPressed: onViewAll, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 8),
          // Unique non-grid layout: staggered, asymmetric tiles
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _TileWide(icon: Icons.receipt_long, title: 'Mobile Recharge'),
              _TileSmall(icon: Icons.fastfood, title: 'Food'),
              _TileSmall(icon: Icons.local_taxi, title: 'Rides'),
              _TileWide(icon: Icons.savings, title: 'Savings Vault'),
              _TileSmall(icon: Icons.lightbulb_outline, title: 'Ideas'),
              _TileSmall(icon: Icons.card_giftcard, title: 'Offers'),
              _TileSmall(icon: Icons.local_offer, title: 'Deals'),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightsCarousel extends StatelessWidget {
  const _InsightsCarousel();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: PageView(
        controller: PageController(viewportFraction: 0.88),
        children: const [
          _BannerCard(text: 'Weekly spend down 12% 🎯'),
          _BannerCard(text: 'Earned 240 reward points ✨'),
          _BannerCard(text: 'Try Auto-Save rules 💾'),
        ],
      ),
    );
  }
}

class _ShortcutsStrip extends StatelessWidget {
  const _ShortcutsStrip();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.07),
        border: Border.all(color: Colors.white12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: const [
            _ChipShortcut('Insurance', Icons.shield_moon),
            _ChipShortcut('Rewards', Icons.card_giftcard),
            _ChipShortcut('Invest', Icons.show_chart),
            _ChipShortcut('Pay Bills', Icons.receipt),
            _ChipShortcut('Cards', Icons.credit_card),
            _ChipShortcut('Tickets', Icons.airplane_ticket),
          ],
        ),
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ...List.generate(5, (i) => _activityTile(i)),
      ],
    );
  }

  Widget _activityTile(int i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF7F53AC), Color(0xFF647DEE)],
              ),
            ),
            child: const Icon(Icons.compare_arrows, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Transfer • QIS Tech',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Text(
            '-₹320',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Decorative sub-widgets ---
class _BannerCard extends StatelessWidget {
  final String text;
  const _BannerCard({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
        boxShadow: [
          BoxShadow(color: Color(0xAA2575FC), blurRadius: 12, spreadRadius: 1),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_graph, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TileSmall extends StatelessWidget {
  final IconData icon;
  final String title;
  const _TileSmall({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 86,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TileBig extends StatelessWidget {
  final IconData icon;
  final String title;
  const _TileBig({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _TileWide extends StatelessWidget {
  final IconData icon;
  final String title;
  const _TileWide({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 86,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _ChipShortcut extends StatelessWidget {
  final String text;
  final IconData icon;
  const _ChipShortcut(this.text, this.icon);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _FABScan extends StatelessWidget {
  final VoidCallback onTap;
  const _FABScan({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        width: 58,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF7F53AC), Color(0xFF647DEE)],
          ),
        ),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
    );
  }
}

class _NeoBottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const _NeoBottomBar({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
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
        minimum: EdgeInsets.zero, // removes default bottom spacing
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_filled, 'Home', 0),
              _navItem(Icons.search, 'Search', 1),
              const SizedBox(width: 56), // space for FAB
              _navItem(Icons.notifications_active, 'Alerts', 2),
              _navItem(Icons.feedback, 'Feedback', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int i) {
    final bool active = i == index;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onTap(i),
      child: SizedBox(
        height: 40, // keeps icon+text compact
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center, // vertical alignment
          children: [
            Icon(
              icon,
              color: active ? Colors.white : Colors.white70,
              size: 20, // smaller icon
            ),
            const SizedBox(height: 2), // reduced gap
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.white70,
                fontSize: 10, // smaller font
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDrawer extends StatelessWidget {
  final VoidCallback onLogout;
  const _ProfileDrawer({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.deepPurple),
                  ),
                  title: Text(
                    'Hi there!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    'View & edit profile',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.account_circle, color: Colors.white),
              title: Text('My Profile', style: TextStyle(color: Colors.white)),
            ),
            const ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text('Settings', style: TextStyle(color: Colors.white)),
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}
