import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server.dart';
import 'package:qlquanao/Customer/GetNewPassword/ForgetPassword.dart';
import 'package:qlquanao/Customer/GetNewPassword/RenewPassword.dart';
import 'package:qlquanao/Customer/mainpage.dart';
import 'package:mailer/mailer.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:rounded_loading_button/rounded_loading_button.dart';

class ConfirmPassword extends StatefulWidget {
  final String code;
  final String email;

  ConfirmPassword({required this.code, required this.email});

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  final codeconfirm = TextEditingController();
  final confirmPasswordController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
        centerTitle: true,
        title: const Text(
          'CONFIRM CODE',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
              child: TextFormField(
                controller: codeconfirm,
                decoration: InputDecoration(
                    hintText: "Enter your CODE sent from email",
                    fillColor: Colors.grey[200],
                    filled: true),
              ),
            ),
            RoundedLoadingButton(
                controller: confirmPasswordController,
                color: Colors.black,
                successColor: Colors.black,
                width: MediaQuery.of(context).size.width * 0.8,
                elevation: 0,
                borderRadius: 25,
                onPressed: () {
                  if (widget.code == codeconfirm.text) {
                    confirmPasswordController.success();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RenewPassword(
                                  email: widget.email,
                                )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Code is not correct')));
                    confirmPasswordController.reset();
                  }
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
                //Navigator.pop(context);
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
    );
  }
}
