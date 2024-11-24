import 'package:flutter/material.dart';

class DatingView extends StatelessWidget {
  const DatingView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> matches = [
      {'name': 'Alice', 'age': 25, 'image': 'https://static.vecteezy.com/system/resources/thumbnails/004/899/680/small_2x/beautiful-blonde-woman-with-makeup-avatar-for-a-beauty-salon-illustration-in-the-cartoon-style-vector.jpg'},
      {'name': 'Bob', 'age': 30, 'image': 'https://media.istockphoto.com/id/1332100919/de/vektor/m%C3%A4nner-ikone-schwarzes-symbol-personensymbol.jpg?s=612x612&w=0&k=20&c=B18829X05YkUnhCWemZmNjOPekogsD7zQX23ATFS6dQ='},
      {'name': 'Charlie', 'age': 28, 'image': 'https://media.istockphoto.com/id/1332100919/de/vektor/m%C3%A4nner-ikone-schwarzes-symbol-personensymbol.jpg?s=612x612&w=0&k=20&c=B18829X05YkUnhCWemZmNjOPekogsD7zQX23ATFS6dQ='},
    ]; // Dummy people with ages and profile pictures

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dates'),
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