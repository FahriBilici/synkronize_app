import 'package:flutter/material.dart';

class SocialView extends StatelessWidget {
  const SocialView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> events = [
      {'name': 'Run Club', 'date': '2023-11-01'},
      {'name': 'Book Club', 'date': '2023-11-15'},
    ]; // Events with dates

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social'),
      ),
      body: events.isEmpty
          ? const Center(
        child: Text('No events currently.'),
      )
          : ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(events[index]['name']!),
            subtitle: Text('Date: ${events[index]['date']}'),
          );
        },
      ),
    );
  }
}