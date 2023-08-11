import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // write your server address
  IOWebSocketChannel channel =
      IOWebSocketChannel.connect('ws://localhost:4000');
  List<String> messages = [];
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // Receive messages from the server
    channel.stream.listen((message) {
      messages.add(message);
      setState(() {});
      print('Received message: $message');
      // Handle the received message and update the UI
    });
    super.initState();
  }

  void sendMessage() {
    channel.sink.add(messageController.text);
      messageController.clear();
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(messages[index].toString()),
          );
        },
      ),
      floatingActionButton: Row(
        children: [
          Expanded(
              flex: 9,
              child: TextFormField(
                controller: messageController,
                decoration:
                    const InputDecoration(hintText: "Type message here"),
              )),
          Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: sendMessage, icon: const Icon(Icons.send_rounded)))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
