import 'package:flutter/material.dart';

class SocialView extends StatelessWidget {
  const SocialView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> friends = [
      {'name': 'John', 'age': 27, 'image': 'https://media.istockphoto.com/id/1332100919/de/vektor/m%C3%A4nner-ikone-schwarzes-symbol-personensymbol.jpg?s=612x612&w=0&k=20&c=B18829X05YkUnhCWemZmNjOPekogsD7zQX23ATFS6dQ='},
      {'name': 'Jane', 'age': 24, 'image': 'https://static.vecteezy.com/system/resources/thumbnails/004/899/680/small_2x/beautiful-blonde-woman-with-makeup-avatar-for-a-beauty-salon-illustration-in-the-cartoon-style-vector.jpg'},
    ]; // Dummy friends with ages and profile pictures

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: friends.isEmpty
          ? const Center(
        child: Text('No friends currently.'),
      )
          : ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(friends[index]['image']),
            ),
            title: Text(friends[index]['name']),
            subtitle: Text('Age: ${friends[index]['age']}'),
          );
        },
      ),
    );
  }
}