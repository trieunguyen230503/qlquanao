import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Admin/fragment/MainPageAdmin.dart';
import 'package:qlquanao/provider/internet_provider.dart';
import 'package:qlquanao/provider/revenue_provider.dart';
import 'package:qlquanao/provider/signin_provider.dart';
import 'package:qlquanao/utils/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignInProvider()),
        ChangeNotifierProvider(create: (context) => RevenueProvider()),
        ChangeNotifierProvider(create: (context) => InternetProvider())
      ],
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
