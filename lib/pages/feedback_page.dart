import 'package:flutter/material.dart';
import '../widgets/neo_bottom_bar.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Tell us what you think',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Submit')),
          ],
        ),
      ),
      bottomNavigationBar: NeoBottomBar(
        index: 3,
        onTap: (i) {
          if (i == 0) {
            Navigator.of(context).pop();
          } else if (i == 1) {
            Navigator.of(context).pushNamed('/search');
          } else if (i == 2) {
            Navigator.of(context).pushNamed('/alerts');
          }
        },
      ),
    );
  }
}
