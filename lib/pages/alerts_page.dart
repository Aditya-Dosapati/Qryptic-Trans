import 'package:flutter/material.dart';
import '../widgets/neo_bottom_bar.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, i) => const ListTile(
          leading: Icon(Icons.warning_amber_rounded, color: Colors.amber),
          title: Text('Important alert'),
          subtitle: Text('Details about the alert'),
        ),
      ),
      bottomNavigationBar: NeoBottomBar(
        index: 2,
        onTap: (i) {
          if (i == 0) {
            Navigator.of(context).pop();
          } else if (i == 1) {
            Navigator.of(context).pushNamed('/search');
          } else if (i == 3) {
            Navigator.of(context).pushNamed('/feedback');
          }
        },
      ),
    );
  }
}
