import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.notifications_active),
          title: Text('New alert #$i'),
          subtitle: const Text('Tap to view details'),
        ),
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: 12,
      ),
    );
  }
}
