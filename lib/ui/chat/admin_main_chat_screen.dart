import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../values/my_colors.dart';
import '../../values/size_config.dart';
import 'admin_chat_screen.dart';

class AdminMainChatScreen extends StatefulWidget {
  const AdminMainChatScreen({Key? key}) : super(key: key);

  @override
  State<AdminMainChatScreen> createState() => _AdminMainChatScreenState();
}

class _AdminMainChatScreenState extends State<AdminMainChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors.primaryColor,
        title: const Text(
          'Chat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('User').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  bool check = true;
                  return ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      if (document.id !=
                          FirebaseAuth.instance.currentUser!.uid) {
                        check = false;
                      } else {
                        check = true;
                      }
                      return check == false
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                elevation: 5.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: MyColors.primaryColor),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 5.0),
                                    leading: Container(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      decoration: const BoxDecoration(
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
                                          fontWeight: FontWeight.bold,
                                          fontSize: getFont(16)),
                                    ),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        const Icon(
                                          Icons.email,
                                          color: Colors.white,
                                          size: 17,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          "${data['email']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            height: 1,
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
                                                AdminChatScreen(
                                              userDocument: document,
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
            ],
          ),
        ),
      ),
    );
  }
}
