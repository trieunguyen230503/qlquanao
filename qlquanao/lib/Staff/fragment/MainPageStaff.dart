import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Admin/fragment/Approving/adminApproveOrder.dart';
import '../../Admin/fragment/fragment/Revenue/Revenue.dart';
import '../../Admin/fragment/fragment/product/HomePageAdmin.dart';
import '../../utils/ProfilePage.dart';

class MainPageStaff extends StatefulWidget {
  const MainPageStaff({super.key});

  @override
  State<MainPageStaff> createState() => _MainPageStaffState();
}

List<Widget> _widgetOptions = <Widget>[
  ApproveOrderPage(),
  HomePageAdmin(),
  Revenue(),
  ProfilePage(),
];

class _MainPageStaffState extends State<MainPageStaff> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
