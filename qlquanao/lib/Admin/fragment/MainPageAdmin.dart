import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qlquanao/Admin/fragment/fragment/account/ManageAccountStaff.dart';
import 'package:qlquanao/Admin/fragment/fragment/Revenue/ManageRevenue.dart';
import 'package:qlquanao/Admin/fragment/fragment/Revenue/Revenue.dart';
import 'package:qlquanao/Admin/fragment/fragment/account/MangeAccount.dart';
import 'package:qlquanao/Admin/fragment/fragment/product/HomePageAdmin.dart';
import 'package:qlquanao/utils/ProfilePage.dart';

import 'Approving/adminApproveOrder.dart';

class MainPageAdmin extends StatefulWidget {
  const MainPageAdmin({super.key});

  @override
  State<MainPageAdmin> createState() => _MainPageAdminState();
}

List<Widget> _widgetOptions = <Widget>[
  ApproveOrderPage(),
  HomePageAdmin(),
  Revenue(),
  ManageAccount(),
  ProfilePage(),
];

class _MainPageAdminState extends State<MainPageAdmin> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   centerTitle: true,
        // ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_rounded), label: 'ORDER'),
            BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.tshirt,
                ),
                label: 'PRODUCT'),
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart), label: 'REVENUE'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_sharp), label: 'ACCOUNT'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
