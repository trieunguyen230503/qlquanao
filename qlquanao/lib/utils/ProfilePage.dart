import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Customer/mainpage.dart';
import 'package:qlquanao/utils/ProfileCustome.dart';
import 'package:qlquanao/utils/opResLogin.dart';
import 'package:qlquanao/provider/signin_provider.dart';
import 'package:qlquanao/utils/emailsender.dart';
import 'package:qlquanao/utils/next_screen.dart';
import 'package:qlquanao/utils/snack_bar.dart';
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
    sp.getDataFromSharedPreference();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
          // Đổi icon về
          onPressed: () {
            Navigator.pop(context);
            // Xử lý khi người dùng nhấn vào icon trở về
          },
        ),
        backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
        centerTitle: true,
        title: const Text(
          'PROFILE',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
          child: Center(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${sp.email}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  InkWell(
                    child: Container(
                      color: Colors.white70,
                      child: ListTile(
                        //tileColor: Colors.grey,
                        title: Text('CHANGE PASSWORD'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        selectedTileColor: Colors.black,
                      ),
                    ),
                    onTap: () {
                      if (sp.provider == "GOOGLE") {
                        openSnackbar(
                            context, "Change password is invalid", Colors.red);
                      } else {
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
                      }
                    },
                  ),
                  InkWell(
                    child: Container(
                      color: Colors.white70,
                      child: ListTile(
                        //tileColor: Colors.grey,
                        title: Text('UPDATE PROFILE'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        selectedTileColor: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileCustome()));
                    },
                  ),
                  InkWell(
                    child: Container(
                      color: Colors.white70,
                      child: ListTile(
                        //tileColor: Colors.grey,
                        title: Text('SIGNOUT'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        selectedTileColor: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      await sp.userSignout();
                      nextScreenReplace(context, const MainPage());
                    },
                  ),
                ],
              ),
            );
          } else {
            return OpResLogin();
          }
        },
      ))),
    );
  }
}
