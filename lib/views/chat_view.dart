import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  final String sender;

  const ChatView({super.key, required this.sender});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonActive = false;
  final List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonActive = _controller.text.isNotEmpty;
      });
    });

    // Add predefined messages
    if (widget.sender == 'Alice') {
      _messages.add({'sender': 'other', 'text': 'Hi there!'});
    } else if (widget.sender == 'Bob') {
      _messages.add({'sender': 'other', 'text': 'Hello!'});
    } else if (widget.sender == 'Charlie') {
      _messages.add({'sender': 'other', 'text': 'Good morning!'});
    }
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'me', 'text': _controller.text});
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.sender}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message['sender'] == 'me';
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        message['text']!,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isMe ? Colors.black : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Aa.',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: _isButtonActive ? Colors.blue : Colors.grey,
                      onPressed: _isButtonActive ? _sendMessage : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}