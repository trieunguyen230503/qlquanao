import 'package:flutter/material.dart';
import 'package:qlquanao/Admin/fragment/fragment/account/ManageAccountStaff.dart';

import 'ManageAccountCustomer.dart';

class ManageAccount extends StatefulWidget {
  const ManageAccount({super.key});

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
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
                'ACCOUNT',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              bottom: TabBar(
                isScrollable: false,
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'STAFF',
                  ),
                  Tab(
                    text: 'CUSTOMER',
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              MangeAccountStaff(),
              ManageAccountCustomer(),
            ],
          ),
        ),
      ),
    );
  }
}
