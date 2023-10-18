import 'package:flutter/material.dart';
import 'package:qlquanao/Admin/fragment/fragment/category/ManageCategory.dart';
import 'package:qlquanao/utils/ProfilePage.dart';

import 'fragment/color/ManageColor.dart';
import 'fragment/product/ManageProduct.dart';
import 'fragment/size/ManageSize.dart';

class MainPageAdmin extends StatefulWidget {
  const MainPageAdmin({super.key});

  @override
  State<MainPageAdmin> createState() => _MainPageAdminState();
}

List<Widget> _widgetOptions = <Widget>[ManageProduct(), ManageColor(), ManageSize(), ManageCategory(), ProfilePage()];

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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
            BottomNavigationBarItem(icon: Icon(Icons.color_lens), label: 'COLOR'),
            BottomNavigationBarItem(icon: Icon(Icons.photo_size_select_small), label: 'SIZE'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: 'CATEGORY'),
            BottomNavigationBarItem(
                icon: Icon(Icons.card_membership_outlined),
                label: 'MEMBERSHIP'),
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
