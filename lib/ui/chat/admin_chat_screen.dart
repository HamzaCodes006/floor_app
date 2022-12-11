import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../values/my_colors.dart';

final _firestore = FirebaseFirestore.instance;
late String messageText;

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({
    Key? key,
    required this.userDocument,
  }) : super(key: key);
  final DocumentSnapshot userDocument;

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  var chatMsgTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: MyColors.primaryColor),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size(25, 2),
          child: Container(
            constraints: const BoxConstraints.expand(height: 1),
            child: const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: MyColors.primaryColor,
            ),
          ),
        ),
        backgroundColor: Colors.white10,
        title: Center(
          child: Text(
            widget.userDocument.get('userName') ?? '',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              color: MyColors.primaryColor,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_sharp),
        ),
        actions: <Widget>[
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: Icon(
                Icons.keyboard_backspace,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          UserChatStream(userDocument: widget.userDocument),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                      child: TextField(
                        onChanged: (value) {
                          messageText = value;
                          print(value);
                        },
                        controller: chatMsgTextController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          hintText: 'Type your message here...',
                          hintStyle:
                              TextStyle(fontFamily: 'Poppins', fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                    shape: const CircleBorder(),
                    color: MyColors.primaryColor,
                    onPressed: () {
                      chatMsgTextController.clear();
                      _firestore
                          .collection('User')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('messages')
                          .add({
                        'assignReceiverUid': widget.userDocument.id,
                        'text': messageText,
                        'lat': 0.0,
                        'long': 0.0,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                        'senderUid': FirebaseAuth.instance.currentUser!.uid,
                        'assignReceiverName':
                            widget.userDocument.get('userName'),
                      }).whenComplete(() => print(
                              'added in firebase from worker chat screen.'));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserChatStream extends StatelessWidget {
  const UserChatStream({super.key, required this.userDocument});

  final DocumentSnapshot userDocument;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          // .collectionGroup('messages')
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
                backgroundColor: MyColors.primaryColor),
          );
        }
        if (snapshot.hasData) {
          print('messages bubbles');
          snapshot.data!.docs.map((e) {
            print(e.get('text'));
          });
          final messages = snapshot.data!.docs.reversed;
          List<UserMessageBubble> messageWidgets = [];
          final receiverUid = userDocument.id;
          for (var message in messages) {
            final msgText = message.get('text');
            final msgSender = message.get('senderUid');
            print('text message: $msgText');
            final assignReceiverUid = message.get('assignReceiverUid');
            final currentUser = FirebaseAuth.instance.currentUser!.uid;
            final msgBubble = UserMessageBubble(
              msgText: msgText,
              msgSender: msgSender,
              user: currentUser == msgSender,
            );
            if ((msgSender == FirebaseAuth.instance.currentUser!.uid &&
                    assignReceiverUid == receiverUid) ||
                (msgSender == receiverUid &&
                    assignReceiverUid ==
                        FirebaseAuth.instance.currentUser!.uid)) {
              // if (assignReceiverEmail == receiverEmail ||
              //     assignReceiverEmail ==
              //         FirebaseAuth.instance.currentUser!.email) {
              messageWidgets.add(msgBubble);
              // }
            }
            // messageWidgets.add(msgBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets,
            ),
          );
        }
        return const Center(
          child: Text('data not found'),
        );
      },
    );
    // : Center(
    //     child: CircularProgressIndicator(
    //       color: Colors.lightGreen,
    //     ),
    //   );
  }
}

class UserMessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;

  const UserMessageBubble({
    super.key,
    required this.msgText,
    required this.msgSender,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              // msgSender,
              '',
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(50),
              topLeft:
                  user ? const Radius.circular(50) : const Radius.circular(0),
              bottomRight: const Radius.circular(50),
              topRight:
                  user ? const Radius.circular(0) : const Radius.circular(50),
            ),
            color: user ? MyColors.primaryColor : MyColors.secondaryColor,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.white : Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
