import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Customer/GetNewPassword/ConfirmPassword.dart';
import 'package:qlquanao/Customer/mainpage.dart';
import 'package:mailer/mailer.dart';
import 'package:http/http.dart' as http;
import 'package:qlquanao/provider/internet_provider.dart';
import 'dart:math';

import 'package:qlquanao/provider/signin_provider.dart';
import 'package:qlquanao/utils/emailsender.dart';
import 'package:qlquanao/utils/snack_bar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/config.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final userName = TextEditingController();
  String code = '';
  final emailController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'ConfirmPass': (context) => ConfirmPassword(
              code: '',
              email: '',
            ),
      },
      home: Scaffold(
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
            'FORGET PASSWORD',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Container(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                child: Image(
                  image: AssetImage(Config.logo),
                  height: 100,
                  width: 100,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: TextFormField(
                  controller: userName,
                  decoration: InputDecoration(
                      hintText: "Enter your email",
                      fillColor: Colors.grey[200],
                      filled: true),
                ),
              ),
              RoundedLoadingButton(
                  controller: emailController,
                  color: Colors.black,
                  successColor: Colors.black,
                  width: MediaQuery.of(context).size.width * 0.8,
                  elevation: 0,
                  borderRadius: 25,
                  onPressed: () {
                    //gán mã code

                    //Chuyển đoạn code sang trang ConfirmPassword
                    checkEmaildata();
                  },
                  child: Wrap(
                    children: const [
                      Icon(
                        Icons.login,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'CONFIRM',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  )),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Text('Return Home Page',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      )),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void checkEmaildata() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    sp.checkEmailExists(userName.text).then((value) {
      if (value == true) {
        code = createCode();
        print(code);
        sendingmail(
            name: 'Trieu',
            email: userName.text.toString(),
            subject: 'Reset your password',
            message: code);
        emailController.success();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmPassword(
                    code: code, email: userName.text.toString())));
      } else {
        emailController.reset();
        openSnackbar(context, "Doesn't exist this email", Colors.red);
      }
    });
  }
}
