import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_view.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> messages = [
      {'sender': 'Alice', 'message': 'Hi there!'},
      {'sender': 'Bob', 'message': 'Hello!'},
      {'sender': 'Charlie', 'message': 'Good morning!'},
    ]; // Dummy messages from 3 people

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: messages.isEmpty
          ? const Center(
        child: Text('No messages currently.'),
      )
          : ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(messages[index]['sender']!),
            subtitle: Text(messages[index]['message']!),
            onTap: () {
              Get.to(() => ChatView(sender: messages[index]['sender']!));
            },
          );
        },
      ),
    );
  }
}