import 'package:flutter/material.dart';
import 'package:qlquanao/Admin/fragment/fragment/account/ManageAccountStaff.dart';
import 'package:qlquanao/Admin/fragment/fragment/ManageProduct.dart';
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
            BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'ORDER'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
            BottomNavigationBarItem(icon: Icon(Icons.color_lens), label: 'COLOR'),
            BottomNavigationBarItem(icon: Icon(Icons.photo_size_select_small), label: 'SIZE'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: 'CATEGORY'),
            BottomNavigationBarItem(
                icon: Icon(Icons.area_chart), label: 'REVENUE'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'ACCOUNT'),
            BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle_outlined),
                label: 'PROFILE'),
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
