import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../values/my_colors.dart';
import '../../values/size_config.dart';
import '../../widget/toasts.dart';

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('All Users'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('User')
                    .where(
                      'approved',
                      isEqualTo: true,
                    )
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  actionsAlignment: MainAxisAlignment.start,
                                  alignment: Alignment.centerLeft,
                                  title: const Text(
                                    "Account Details!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Username: ${document.get('userName')}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Email: ${document.get('email')}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Text(
                                        "User Height: {document.get('userHeight')}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Text(
                                        "User Latitude: {document.get('userLatitude')}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Text(
                                        "User Longitude: {document.get('userLongitude')}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Container(
                                            color: Colors.green,
                                            padding: const EdgeInsets.all(14),
                                            child: const Text(
                                              "Okay",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                            FirebaseFirestore.instance
                                                .collection('User')
                                                .doc(document.id)
                                                .delete()
                                                .then((doc) {
                                              CustomToast.successToast(
                                                  msg: 'Deleted Successfully!');
                                            });
                                          },
                                          child: Container(
                                            color: Colors.red,
                                            padding: const EdgeInsets.all(14),
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
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
                                                  color: Colors.white))),
                                      child: Image.asset(
                                        "assets/images/logo.png",
                                        color: Colors.white,
                                        width: getWidth(40),
                                        height: getHeight(40),
                                      ),
                                    ),
                                    title: Text(
                                      "${document.get('userName')}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: getFont(16)),
                                    ),
                                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                    subtitle: Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.email,
                                          color: Colors.white,
                                          size: 17,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text("${document.get('email')}",
                                            style: const TextStyle(
                                                color: Colors.white))
                                      ],
                                    ),
                                    trailing: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.white,
                                        size: 30.0)),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
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
