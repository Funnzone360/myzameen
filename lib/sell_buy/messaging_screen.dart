import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessagingScreen extends StatefulWidget {
  final String sellerName;

  const MessagingScreen({Key? key, required this.sellerName}) : super(key: key);

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  TextEditingController messageController = TextEditingController();
  List<Message> messages = [];
  late CollectionReference messagesCollection;

  @override
  void initState() {
    super.initState();
    messagesCollection = FirebaseFirestore.instance.collection('messages');
    fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messaging with ${widget.sellerName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: messages.isEmpty
                    ? Center(
                        child: Text('No messages yet.'),
                      )
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          Message message = messages[index];
                          return GestureDetector(
                            onLongPress: () {
                              showDeleteDialog(message);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${message.sender}: ${message.text}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: message.sender == 'Seller'
                                      ? Colors.green
                                      : Colors.blue,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    sendMessage();
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      String sender = 'Buyer';
      await messagesCollection.add({
        'sellerName': widget.sellerName,
        'sender': sender,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        messages.add(Message(
          sender: sender,
          text: messageText,
          sellerName: widget.sellerName,
          timestamp: Timestamp.now(),
        ));
        messageController.clear();
      });
    }
  }

  void fetchMessages() async {
    try {
      QuerySnapshot<Object?> querySnapshot = await messagesCollection.get();

      List<Message> fetchedMessages = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Message(
          sender: data['sender'],
          text: data['text'],
          sellerName: data['sellerName'],
          timestamp: data['timestamp'],
        );
      }).toList();

      setState(() {
        messages = fetchedMessages;
      });
    } catch (e) {
      print("Error fetching messages: $e");
      // Handle error here, you might want to show a snackbar or display an error message
    }
  }

  void showDeleteDialog(Message message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Message'),
          content: Text('Do you want to delete this message?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteMessage(message);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void deleteMessage(Message message) async {
    // Delete the message from Firestore
    await messagesCollection
        .where('sellerName', isEqualTo: widget.sellerName)
        .where('text', isEqualTo: message.text)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    fetchMessages();
  }
}

class Message {
  final String sender;
  final String text;
  final String sellerName;
  final Timestamp timestamp;

  Message({
    required this.sender,
    required this.text,
    required this.sellerName,
    required this.timestamp,
  });
}
