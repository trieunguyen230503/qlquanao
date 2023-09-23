import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server.dart';
import 'package:qlquanao/ForgetPassword.dart';
import 'package:qlquanao/RenewPassword.dart';
import 'package:qlquanao/mainpage.dart';
import 'package:mailer/mailer.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class ConfirmPassword extends StatefulWidget {
  final String code;
  final String email;

  ConfirmPassword({required this.code, required this.email});

  @override
  State<ConfirmPassword> createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  final codeconfirm = TextEditingController();

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
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: ElevatedButton(
                onPressed: () {
                  if (widget.code == codeconfirm.text) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RenewPassword(
                                  email: widget.email,
                                )));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Code is not correct')));
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                child: const Text(
                  'CONFIRM',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
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
