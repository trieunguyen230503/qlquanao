import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Customer/mainpage.dart';
import 'package:qlquanao/provider/internet_provider.dart';
import 'package:qlquanao/provider/signin_provider.dart';
import 'package:qlquanao/utils/next_screen.dart';
import 'package:qlquanao/utils/snack_bar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/Login.dart';
import '../../database.dart';

class RenewPassword extends StatefulWidget {
  final String email;

  const RenewPassword({required this.email});

  @override
  State<RenewPassword> createState() => _RenewPasswordState();
}

class _RenewPasswordState extends State<RenewPassword> {

  final password = TextEditingController();
  final confirmpassword = TextEditingController();

  bool _obscureText = true;
  bool _obscureText1 = true;

  final renewPassowrd = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black,
          ),
          // Đổi icon về
          onPressed: () {
            // Xử lý khi người dùng nhấn vào icon trở về
          },
        ),
        backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
        centerTitle: true,
        title: const Text(
          'RENEW PASSWORD',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: TextFormField(
                  obscureText: _obscureText,
                  controller: confirmpassword,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: TextFormField(
                  obscureText: _obscureText1,
                  controller: password,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;
                        });
                      },
                      child: Icon(_obscureText1
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                    hintText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              RoundedLoadingButton(
                  controller: renewPassowrd,
                  successColor: Colors.black,
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width * 0.8,
                  elevation: 0,
                  borderRadius: 25,
                  onPressed: () {
                    updateData();
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
                        'Renew Password',
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
                  child: Text('Return Home page ',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateData() async {
    if (confirmpassword.text == password.text) {
      if (confirmpassword.text.length > 8) {
        final sp = context.read<SignInProvider>();
        final ip = context.read<InternetProvider>();
        await ip.checkInternetConnection();

        sp.updateForgetPass(widget.email, password.text.toString());
        openSnackbar(context, "Successful", Colors.green);
        renewPassowrd.success();
        nextScreenReplace(context, MainPage());
      } else {
        openSnackbar(context, "Password must be 8 character", Colors.red);
        renewPassowrd.reset();
      }
    } else {
      openSnackbar(context, "Password doesn't match", Colors.red);
      renewPassowrd.reset();
    }
  }
}
