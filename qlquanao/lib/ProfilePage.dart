import 'package:flutter/material.dart';
import 'package:qlquanao/opResLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences logindata;
  bool checklogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void check() async {}

  Future<bool> Check() async {
    logindata = await SharedPreferences.getInstance();
    checklogin = logindata.getBool('login') ?? false;
    return checklogin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
          centerTitle: true,
          title: const Text(
            'PROFILE',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Center(
            child: FutureBuilder<bool?>(
          future: Check(),
          builder: (context, snapshot) {
            if (checklogin == true) {
              return Text('Hello');
            } else {
              return OpResLogin();
            }
          },
        )));
  }
}
