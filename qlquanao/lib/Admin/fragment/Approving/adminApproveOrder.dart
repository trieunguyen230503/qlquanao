import 'package:flutter/material.dart';

import 'ApprovedPage.dart';
import 'ApprovingPage.dart';

class ApproveOrderPage extends StatefulWidget {
  const ApproveOrderPage({super.key});

  @override
  State<ApproveOrderPage> createState() => _ApproveOrderPageState();
}

class _ApproveOrderPageState extends State<ApproveOrderPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(),
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * (1 / 8)),
            child: AppBar(
              backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
              centerTitle: true,
              title: const Text(
                'Browse orders',
                style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'Awaiting approval',
                  ),
                  Tab(
                    text: 'Approved',
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              ApprovingPage(),
              ApprovedPage(),
            ],
          ),
        ),
      ),
    );
  }
}
