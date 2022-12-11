import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor_app/ui/map_tracking_screen.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/values/size_config.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

import '../../data/singleton/singleton.dart';

// import '../providers/chat_provider.dart';

final _firestore = FirebaseFirestore.instance;
// late String email;
late String messageText;

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({
    super.key,
    required this.userDocument,
  });

  final DocumentSnapshot userDocument;

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  var chatMsgTextController = TextEditingController();
  double? userLatitude;
  double? userLongitude;

  @override
  void initState() {
    //uIdGet().whenComplete(() => setState(() {}));
    // setState(() {
    getCurrentUserLocation();
    super.initState();
  }

  getCurrentUserLocation() async {
    loc.Location location = loc.Location();
    loc.PermissionStatus status = await location.requestPermission();
    if (status == loc.PermissionStatus.granted ||
        status == loc.PermissionStatus.granted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // int userId = int.parse(GetLocalStorage().getUserId());
      userLatitude = position.latitude;
      userLongitude = position.longitude;
    }
    // try {
    //   // QuerySnapshot querySnapshot = await _firestore
    //   //     .collection('User')
    //   //     .where('Email', isEqualTo: '${widget.assignUserEmail}')
    //   //     .get();
    //   // assignUserId = querySnapshot.docs.first.id;
    //   // print("aaa//////////////////////${querySnapshot.docs.first.id}");
    //   // final user = await _auth.currentUser!;
    //   // if (user != null) {
    //   //   loggedInUser = user;
    //   //   setState(() {
    //   //     email = loggedInUser.email!;
    //   //     print('///////////////////////////$email');
    //   //   });
    //   }

    //   print("aaa//////////////////////");
    // } catch (e) {
    //   print('current user getting error');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size(25, 2),
          child: Container(
            decoration: const BoxDecoration(
                // color: Colors.blue,
                // borderRadius: BorderRadius.circular(20)
                ),
            constraints: const BoxConstraints.expand(height: 1),
            child: const LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: MyColors.primaryColor,
            ),
          ),
        ),
        backgroundColor: MyColors.primaryColor,
        // leading: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: CircleAvatar(backgroundImage: NetworkImage('https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png'),),
        // ),
        title: Center(
          child: Text(
            widget.userDocument.get('userName') ?? '',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              // color: Colors.blueAccent,
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
                color: MyColors.primaryColor,
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          UserChatStream(
            userDocument: widget.userDocument,
            // userLat: widget.userDocument.get('lat'),
            // userLong: widget.userDocument.get('long'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(10)),
                  child: IconButton(
                    onPressed: () async {
                      // getCurrentUserLocation();
                      if (userLatitude != null && userLongitude != null) {
                        await _firestore
                            .collection('User')
                            .doc(widget.userDocument.id)
                            .collection('messages')
                            .add(
                          {
                            'assignReceiverUid': widget.userDocument.id,
                            'text': 'messageText',
                            'lat': userLatitude,
                            'long': userLongitude,
                            'timestamp': DateTime.now().millisecondsSinceEpoch,
                            'senderUid': FirebaseAuth.instance.currentUser!.uid,
                            'assignReceiverName':
                                widget.userDocument.get('userName'),
                          },
                        ).whenComplete(
                          () => print(
                              'added in firebase from worker chat screen.'),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.add_location_alt,
                      color: MyColors.primaryColor,
                      size: getHeight(50),
                    ),
                  ),
                ),
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
                        .doc(widget.userDocument.id)
                        .collection('messages')
                        .add({
                      'assignReceiverUid': widget.userDocument.id,
                      'text': messageText,
                      'lat': 0.0,
                      'long': 0.0,
                      'timestamp': DateTime.now().millisecondsSinceEpoch,
                      'senderUid': FirebaseAuth.instance.currentUser!.uid,
                      'assignReceiverName': widget.userDocument.get('userName'),
                    }).whenComplete(
                      () => print('added in firebase from worker chat screen.'),
                    );
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Icon(Icons.add_location_alt,color: MyColors.primaryColor,size: getHeight(45),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserChatStream extends StatelessWidget {
  const UserChatStream({
    super.key,
    required this.userDocument,
    // required this.userLat,
    // required this.userLong,
  });

  final DocumentSnapshot userDocument;

  // final double? userLat;
  // final double? userLong;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          // .collection('User')
          // .doc(userDocument.id)
          .collectionGroup('messages')
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
              userLat: message.get('lat'),
              userLong: message.get('long'),
              documentSnapshot: userDocument,
            );
            if ((msgSender == FirebaseAuth.instance.currentUser!.uid &&
                    assignReceiverUid == receiverUid) ||
                (msgSender == receiverUid &&
                    assignReceiverUid ==
                        FirebaseAuth.instance.currentUser!.uid)) {
              messageWidgets.add(msgBubble);
            }
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets,
            ),
          );
        }
        return const Text('data not found');
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
  final double? userLat;
  final double? userLong;
  final bool user;
  final DocumentSnapshot documentSnapshot;

  const UserMessageBubble({
    super.key,
    required this.msgText,
    required this.msgSender,
    required this.user,
    required this.userLat,
    required this.userLong,
    required this.documentSnapshot,
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
              bottomLeft: const Radius.circular(20),
              topLeft:
                  user ? const Radius.circular(20) : const Radius.circular(0),
              bottomRight: const Radius.circular(20),
              topRight:
                  user ? const Radius.circular(0) : const Radius.circular(20),
            ),
            color: user ? MyColors.primaryColor : MyColors.secondaryColor,
            elevation: 5,
            child: msgText == 'messageText'
                ? InkWell(
                    onTap: !user
                        ? () {
                            SingleToneValue.instance.user2Lat = userLat;
                            SingleToneValue.instance.user2Lng = userLong;
                            SingleToneValue.instance.user2Height=documentSnapshot.get('userHeight');
                            SingleToneValue.instance.user2Name=documentSnapshot.get('userName');

                            Get.to(MapTrackingScreen());
                            print('print');
                            print(userLat);
                            print(userLong);
                          }
                        : () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: user ? Colors.white : Colors.white,
                            size: getHeight(50),
                          ),
                          Text(
                            'Location',
                            style: TextStyle(
                              color: user ? Colors.white : Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
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
