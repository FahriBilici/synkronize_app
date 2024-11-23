import 'package:flutter/material.dart';

class DatingView extends StatelessWidget {
  const DatingView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> matches = [
      {'name': 'Alice', 'age': 25, 'image': 'https://via.placeholder.com/150'},
      {'name': 'Bob', 'age': 30, 'image': 'https://via.placeholder.com/150'},
      {'name': 'Charlie', 'age': 28, 'image': 'https://via.placeholder.com/150'},
    ]; // Dummy people with ages and profile pictures

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dating'),
      ),
      body: matches.isEmpty
          ? const Center(
        child: Text('No matches currently.'),
      )
          : ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(matches[index]['image']),
            ),
            title: Text(matches[index]['name']),
            subtitle: Text('Age: ${matches[index]['age']}'),
          );
        },
      ),
    );
  }
}