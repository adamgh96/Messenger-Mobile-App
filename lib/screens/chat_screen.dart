import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/screens/registration_screen.dart';
import 'package:messenger_app/screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
late User signedInUser;

class ChatScreen extends StatefulWidget {
  static const String chatRoute = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  final messageControler = TextEditingController();

  String? messageText;
  //late User signedInUser;

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _fireStore.collection('message').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }
  // void messagesStreams() async {
  //   await for (var snapshot in _fireStore.collection('message').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset(
              'images/logo.png',
              height: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Text('Message Me'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              //add log out function

              _auth.signOut();
              Navigator.pop(context);
              //getMessages();
              //messagesStreams();
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: messageControler,
                      onChanged: ((value) {
                        messageText = value;
                      }),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        hintText: 'Enter Your Messager here',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageControler.clear();
                      _fireStore.collection('message').add(
                        {
                          'text': messageText,
                          'sender': signedInUser.email,
                          'time': FieldValue.serverTimestamp(),
                        },
                      );
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue[800]),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('message').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<Messageline> messageWidgets = [];

        if (!snapshot.hasData) {
          // add here a spinner
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');

          final currentUser = signedInUser.email;

          final messageWidget = Messageline(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class Messageline extends StatelessWidget {
  const Messageline({
    Key? key,
    this.sender,
    this.text,
    required this.isMe,
  }) : super(key: key);
  final String? sender;
  final String? text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: isMe
                ? TextStyle(color: Colors.grey)
                : TextStyle(color: Colors.orange[500]),
          ),
          Material(
            elevation: 8,
            color: isMe ? Colors.blue[300] : Colors.orange[300],
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('$text', style: const TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
