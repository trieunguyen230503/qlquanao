import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qlquanao/Customer/Order/CartPage.dart';
import 'package:qlquanao/Customer/fragment/Page1.dart';

import '../../database.dart';
import '../../model/User.dart';
import 'Page2.dart';
import 'Page3.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper dbHelper = new DBHelper();
  late List<User> user;

  Future<List<User>> _ShowData() async {
    await dbHelper.copyDB();
    user = (await dbHelper.getUser());
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(),
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * (1 / 8)),
            child: AppBar(
              backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
              centerTitle: true,
              title: const Text(
                'HOME',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              actions: [
                IconButton(
                  padding: EdgeInsets.only(right: 20),
                  color: Colors.black,
                  icon: Icon(Icons.shopping_cart), // Icon bạn muốn sử dụng
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                  },
                ),
              ],
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'Page 1',
                  ),
                  Tab(
                    text: 'Page 2',
                  ),
                  Tab(
                    text: 'Page 3',
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Page1(),
              Page2(),
              Page3(),
            ],
          ),
        ),
      ),
    );
  }
}
