import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlquanao/Admin/fragment/fragment/product/product/ManageProduct.dart';
import 'package:qlquanao/Admin/fragment/fragment/product/size/ManageSize.dart';

import 'category/ManageCategory.dart';
import 'color/ManageColor.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(),
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * (1 / 8)),
            child: AppBar(
              backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
              centerTitle: true,
              title: const Text(
                'PRODUCT',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              bottom: const TabBar(
                isScrollable: true,
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'PRODUCT',
                  ),
                  Tab(
                    text: 'CATEGORY',
                  ),
                  Tab(
                    text: 'COLOR',
                  ),
                  Tab(
                    text: 'SIZE',
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              ManageProduct(),
              ManageCategory(),
              ManageColor(),
              ManageSize(),
            ],
          ),
        ),
      ),
    );
  }
}
