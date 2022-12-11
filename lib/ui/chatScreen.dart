import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  Chat({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<Chat> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              // child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Chat',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  // widget _entryField(String title, {bool isPassword = false}) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <widget>[
  //         Text(
  //           title,
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         TextField(
  //             obscureText: isPassword,
  //             decoration: InputDecoration(
  //                 border: InputBorder.none,
  //                 fillColor: Color(0xfff3f3f4),
  //                 filled: true))
  //       ],
  //     ),
  //   );
  // }

  // widget _submitButton() {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => HomePage()));
  //     },
  //     child: Container(
  //       width: MediaQuery.of(context).size.width,
  //       padding: EdgeInsets.symmetric(vertical: 15),
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.all(Radius.circular(5)),
  //           boxShadow: <BoxShadow>[
  //             BoxShadow(
  //                 color: Colors.grey.shade200,
  //                 offset: Offset(2, 4),
  //                 blurRadius: 5,
  //                 spreadRadius: 2)
  //           ],
  //           gradient: LinearGradient(
  //               begin: Alignment.centerLeft,
  //               end: Alignment.centerRight,
  //               colors: [Color(0xfffbb448), Color(0xfff7892b)])),
  //       child: Text(
  //         'Login',
  //         style: TextStyle(fontSize: 20, color: Colors.white),
  //       ),
  //     ),
  //   );
  //
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     padding: EdgeInsets.symmetric(vertical: 15),
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(5)),
  //         boxShadow: <BoxShadow>[
  //           BoxShadow(
  //               color: Colors.grey.shade200,
  //               offset: Offset(2, 4),
  //               blurRadius: 5,
  //               spreadRadius: 2)
  //         ],
  //         gradient: LinearGradient(
  //             begin: Alignment.centerLeft,
  //             end: Alignment.centerRight,
  //             colors: [Color(0xfffbb448), Color(0xfff7892b)])),
  //     child: Text(
  //       'Login',
  //       style: TextStyle(fontSize: 20, color: Colors.white),
  //     ),
  //   );
  // }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  // widget _facebookButton() {
  //   return Container(
  //     height: 50,
  //     margin: EdgeInsets.symmetric(vertical: 20),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(10)),
  //     ),
  //     child: Row(
  //       children: <widget>[
  //         Expanded(
  //           flex: 1,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Color(0xff1959a9),
  //               borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(5),
  //                   topLeft: Radius.circular(5)),
  //             ),
  //             alignment: Alignment.center,
  //             child: Text('f',
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 25,
  //                     fontWeight: FontWeight.w400)),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 5,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Color(0xff2872ba),
  //               borderRadius: BorderRadius.only(
  //                   bottomRight: Radius.circular(5),
  //                   topRight: Radius.circular(5)),
  //             ),
  //             alignment: Alignment.center,
  //             child: Text('Log in with Facebook',
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w400)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // widget _createAccountLabel() {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => SignUpPage()));
  //     },
  //     child: Container(
  //       margin: EdgeInsets.symmetric(vertical: 20),
  //       padding: EdgeInsets.all(15),
  //       alignment: Alignment.bottomCenter,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <widget>[
  //           Text(
  //             'Don\'t have an account ?',
  //             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           Text(
  //             'Register',
  //             style: TextStyle(
  //                 color: Color(0xfff79c4f),
  //                 fontSize: 13,
  //                 fontWeight: FontWeight.w600),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // widget _title() {
  //   return RichText(
  //     textAlign: TextAlign.center,
  //     text: TextSpan(
  //         text: 'Floor',
  //         style: GoogleFonts.portLligatSans(
  //           textStyle: Theme.of(context).textTheme.headline1,
  //           fontSize: 30,
  //           fontWeight: FontWeight.w700,
  //           color: Colors.black,
  //         ),
  //         children: [
  //           TextSpan(
  //             text: 'Ident',
  //             style: TextStyle(color: Colors.black, fontSize: 30),
  //           ),
  //           TextSpan(
  //             text: 'ification',
  //             style: TextStyle(color: Colors.black, fontSize: 30),
  //           ),
  //         ]),
  //   );
  // }

  // widget _emailPasswordWidget() {
  //   return Column(
  //     children: <widget>[
  //       _entryField("Email id"),
  //       _entryField("Password", isPassword: true),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
        ),
      body: ListView.builder(
        itemCount: Users.length,
        itemBuilder: (BuildContext context, int index) {
          var User = Users[index];
          return ListTile(
            title: Text(User.name),
            subtitle: Text(User.detail),
            leading: FlutterLogo(),
            trailing: IconButton(
              icon: Icon(User.isFav ? Icons.favorite : Icons.favorite_border),
              onPressed: () => {
                setState(
                      () {
                    User.isFav = !User.isFav;
                  },
                )
              },
            ),
          );
        },
      ),
);
  }
}

List<User> Users = [
  User('User 0', 'about User 0'),
  User('User 1', 'about User 1'),
  User('User 2', 'about User 2'),
  User('User 3', 'about User 3'),
  User('User 4', 'about User 4'),
  User('User 5', 'about User 5'),
  User('User 6', 'about User 6'),
];

class User {
  final String name;
  final String detail;
  bool isFav;

  User(this.name, this.detail, {this.isFav = false});
}
