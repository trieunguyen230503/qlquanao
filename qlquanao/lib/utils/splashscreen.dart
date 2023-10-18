import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Admin/fragment/MainPageAdmin.dart';
import 'package:qlquanao/Customer/mainpage.dart';
import 'package:qlquanao/provider/signin_provider.dart';
import 'package:qlquanao/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/next_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreference();
    super.initState();
    Timer(const Duration(seconds: 2), () {
      // sp.isSignedIn == false
      //     ? nextScreen(context, LoginScreen())
      //     : nextScreen(context, const HomeScreen());
      print(sp.role);
      if (sp.role == 1) {
        nextScreenReplace(context, const MainPageAdmin());
      } else if (sp.role == 2) {
      } else {
        nextScreenReplace(context, const MainPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Image(
      image: AssetImage(Config.google_icon),
      height: 80,
      width: 80,
    )));
  }
}
