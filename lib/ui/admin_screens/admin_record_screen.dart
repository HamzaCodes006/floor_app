import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/values/size_config.dart';
import 'package:floor_app/widget/toasts.dart';
import 'package:flutter/material.dart';

class AdminRecordScreen extends StatelessWidget {
  const AdminRecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('All Members'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('User').snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final List userName = snapshot.data!.docs.map((e) {
                  return e['userName'];
                }).toList();
                final List userEmail = snapshot.data!.docs.map((e) {
                  return e['email'];
                }).toList();
                if (snapshot.hasError) {
                  return CustomToast.failToast(msg: 'Something went wrong');
                }
                if (snapshot.hasData) {
                  return Card(
                    elevation: 5.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(color: MyColors.primaryColor),
                      child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.white))),
                            child: Image.asset(
                              "assets/images/logo.png",
                              color: Colors.white,
                              width: getWidth(40),
                              height: getHeight(40),
                            ),
                          ),
                          title: Text(
                            userName[index],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: getFont(16)),
                          ),
                          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                          subtitle: Row(
                            children: <Widget>[
                              Icon(
                                Icons.email,
                                color: Colors.white,
                                size: 17,
                              ),
                              SizedBox(width: 3,),
                              Text(userEmail[index],
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right,
                              color: Colors.white, size: 30.0)),
                    ),
                  );
                }
                return const Center(
                    child: CircularProgressIndicator(
                  color: MyColors.primaryColor,
                ));
              },
            );
          }),
    );
  }
}
