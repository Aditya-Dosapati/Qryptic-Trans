import 'package:flutter/material.dart';
import '../widgets/neo_bottom_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search anything...',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NeoBottomBar(
        index: 1,
        onTap: (i) {
          if (i == 0) {
            Navigator.of(context).pop();
          } else if (i == 2) {
            Navigator.of(context).pushNamed('/alerts');
          } else if (i == 3) {
            Navigator.of(context).pushNamed('/feedback');
          }
        },
      ),
    );
  }
}
