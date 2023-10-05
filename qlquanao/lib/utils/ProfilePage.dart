import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Customer/mainpage.dart';
import 'package:qlquanao/utils/ProfileCustome.dart';
import 'package:qlquanao/utils/opResLogin.dart';
import 'package:qlquanao/provider/signin_provider.dart';
import 'package:qlquanao/utils/emailsender.dart';
import 'package:qlquanao/utils/next_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Customer/GetNewPassword/ConfirmPassword.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool checklogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Check();
  }

  Future<bool> Check() async {
    final sp = context.read<SignInProvider>();
    checklogin = sp.isSignedIn;
    print(checklogin);
    return checklogin;
  }

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreference();
    print(sp.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();

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
              getData();
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage("${sp.imageUrl}"),
                      radius: 50,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Welcome ${sp.name}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${sp.email}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${sp.address}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Phone"),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${sp.phone}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          sp.userSignout();
                          nextScreenReplace(context, const MainPage());
                        },
                        child: const Text(
                          "SIGNOUT",
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          String code = createCode();
                          sendingmail(
                              name: sp.name.toString(),
                              email: sp.email.toString(),
                              subject: 'Change your password',
                              message: code);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConfirmPassword(
                                      code: code, email: sp.email.toString())));
                        },
                        child: const Text(
                          "Change your password",
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileCustome()));
                        },
                        child: const Text(
                          "Update your profile",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              );
            } else {
              return OpResLogin();
            }
          },
        )));
  }
}
