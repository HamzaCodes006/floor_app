import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor_app/ui/chat/user_chat_screen.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/values/size_config.dart';

// import 'package:floor_app/chat/user_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class UserMainChatScreen extends StatefulWidget {
  const UserMainChatScreen({super.key});

  @override
  _UserMainChatScreenState createState() => _UserMainChatScreenState();
}

class _UserMainChatScreenState extends State<UserMainChatScreen> {
  var chatMsgTextController = TextEditingController();
  late DocumentSnapshot doc;
  bool loading = true;

  @override
  void initState() {
    getAdminData();
    super.initState();
  }

  getAdminData() async {
    doc = await FirebaseFirestore.instance
        .collection('User')
        .doc('mujn8IyS7BZD3NgF7u1kpGdf5NC3')
        .get();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    SizeConfig().init(context);
    return DefaultTabController(
      length: 2,
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(getHeight(100)),
                child: AppBar(
                  backgroundColor: MyColors.primaryColor,
                  leading: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  title: const Text('Chat'),
                  centerTitle: true,
                  bottom: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: MyColors.black.withOpacity(0.38),
                    tabs: const [
                      Tab(
                        text: 'Personal Chat',
                      ),
                      Tab(
                        text: 'Customer Support',
                      ),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: getHeight(800),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('User')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text("Loading");
                                }
                                bool check = true;
                                return ListView(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data =
                                        document.data() as Map<String, dynamic>;
                                    if (document.id !=
                                            FirebaseAuth
                                                .instance.currentUser!.uid &&
                                        document.id !=
                                            'mujn8IyS7BZD3NgF7u1kpGdf5NC3') {
                                      check = false;
                                    } else {
                                      check = true;
                                    }
                                    return check == false
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Card(
                                              elevation: 5.0,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 6.0),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color:
                                                        MyColors.primaryColor),
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20.0,
                                                          vertical: 5.0),
                                                  leading: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 12.0),
                                                    decoration:
                                                        const BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                          width: 1.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.person_pin,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    "${data['userName'].toString().toUpperCase().capitalize}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: getFont(16)),
                                                  ),
                                                  subtitle: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      const Icon(
                                                        Icons.email,
                                                        color: Colors.white,
                                                        size: 17,
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      SizedBox(
                                                        width: getWidth(150),
                                                        child: Text(
                                                          "${data['email']}",
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            height: 1,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  trailing: IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              UserChatScreen(
                                                            userDocument:
                                                                document,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.chat,
                                                      size: 28,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container();
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///2nd tab from here
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      UserChatStream(
                        userDocument: doc,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Material(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 2, bottom: 2),
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
                                      hintStyle: TextStyle(
                                          fontFamily: 'Poppins', fontSize: 14),
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
                                  FirebaseFirestore.instance
                                      .collection('User')
                                      .doc(doc.id)
                                      .collection('messages')
                                      .add({
                                    'assignReceiverUid': doc.id,
                                    'text': messageText,
                                    'lat': 0.0,
                                    'long': 0.0,
                                    'timestamp':
                                        DateTime.now().millisecondsSinceEpoch,
                                    'senderUid':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'assignReceiverName': doc.get('userName'),
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
                  )
                ],
              ),
            ),
    );
  }
}
