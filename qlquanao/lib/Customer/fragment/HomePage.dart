import 'package:flutter/material.dart';

import '../../database.dart';
import '../../model/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // DBHelper dbHelper = new DBHelper();
  // late List<User> user;
  //
  // Future<List<User>> _ShowData() async {
  //   await dbHelper.copyDB();
  //   user = (await dbHelper.getUser());
  //   return user;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
      ),
      // body: FutureBuilder<List<User>?>(
      //   future: _ShowData(),
      //   builder: (context, snapshot) {
      //     return ListView.builder(
      //         itemCount: user.length,
      //         itemBuilder: (context, index) {
      //           return ListTile(
      //             leading: Text(
      //               user[index].id.toString(),
      //               style: TextStyle(color: Colors.black),
      //             ),
      //             title: Text(user[index].UserName.toString() +
      //                 " " +
      //                 user[index].Password.toString()),
      //           );
      //         });
      //   },
      // ),
    );
  }
}
