import 'package:flutter/material.dart';
import 'package:qlquanao/Admin/fragment/fragment/Revenue/ManageRevenue.dart';

import 'MangeRevueProduct.dart';


class Revenue extends StatefulWidget {
  const Revenue({super.key});

  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
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
                'REVENUE',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'Period',
                  ),
                  Tab(
                    text: 'Product',
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              ManageRevenue(),
              MangeReveuneProduct(),
            ],
          ),
        ),
      ),
    );
  }
}
