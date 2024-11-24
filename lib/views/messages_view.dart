import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_view.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final List<Map<String, dynamic>> messages = [
    {
      'sender': 'Alice',
      'message': 'Hi there!',
      'image': 'https://static.vecteezy.com/system/resources/thumbnails/004/899/680/small_2x/beautiful-blonde-woman-with-makeup-avatar-for-a-beauty-salon-illustration-in-the-cartoon-style-vector.jpg',
      'time': '10:30 AM',
      'unread': 1,
      'isOnline': true,
    },
    {
      'sender': 'Bob',
      'message': 'Hello!',
      'image': 'https://media.istockphoto.com/id/1332100919/de/vektor/m%C3%A4nner-ikone-schwarzes-symbol-personensymbol.jpg?s=612x612&w=0&k=20&c=B18829X05YkUnhCWemZmNjOPekogsD7zQX23ATFS6dQ=',
      'time': '9:45 AM',
      'unread': 0,
      'isOnline': false,
    },
    {
      'sender': 'Charlie',
      'message': 'Good morning!',
      'image': 'https://media.istockphoto.com/id/1332100919/de/vektor/m%C3%A4nner-ikone-schwarzes-symbol-personensymbol.jpg?s=612x612&w=0&k=20&c=B18829X05YkUnhCWemZmNjOPekogsD7zQX23ATFS6dQ=',
      'time': 'Yesterday',
      'unread': 1,
      'isOnline': true,
    },
  ];

  void _markAsRead(int index) {
    setState(() {
      messages[index]['unread'] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Implement more options
            },
          ),
        ],
      ),
      body: messages.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a conversation with your friends',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return InkWell(
            onTap: () {
              _markAsRead(index);
              Get.to(() => ChatView(
                sender: message['sender']!,
                imageUrl: message['image']!,
              ));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(message['image']),
                      ),
                      if (message['isOnline'])
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              message['sender'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              message['time'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                message['message'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: message['unread'] > 0
                                      ? Colors.black87
                                      : Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (message['unread'] > 0)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  message['unread'].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}