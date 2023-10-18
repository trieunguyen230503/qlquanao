import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/utils/Login.dart';
import 'package:qlquanao/provider/signin_provider.dart';
import 'package:qlquanao/utils/next_screen.dart';
import 'package:qlquanao/utils/snack_bar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../mainpage.dart';

class ConfirmEmail extends StatefulWidget {
  final String code;
  final String email;
  final String name;
  final String phone;
  final String password;
  final String dob;
  ConfirmEmail(
      {required this.code,
      required this.email,
      required this.name,
      required this.phone,
      required this.password,
      required this.dob});

  @override
  State<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  final codeconfirm = TextEditingController();
  final confirmController = RoundedLoadingButtonController();

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
                controller: confirmController,
                successColor: Colors.blue,
                width: MediaQuery.of(context).size.width * 0.8,
                elevation: 0,
                borderRadius: 25,
                onPressed: () {
                  if (widget.code == codeconfirm.text) {
                    final sp = context.read<SignInProvider>();
                    sp.CreateNewAccount(widget.email, widget.name,
                        widget.password, widget.phone, widget.dob);
                    sp.saveDateToFirestore();
                    openSnackbar(context, "Successful", Colors.green);
                    confirmController.success();
                    nextScreenReplace(context, Login());
                  } else {
                    openSnackbar(context, "Code is not correct", Colors.red);
                    confirmController.reset();
                  }
                },
                child: Wrap(
                  children: const [
                    Icon(
                      FontAwesomeIcons.check,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Confirm Code',
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
