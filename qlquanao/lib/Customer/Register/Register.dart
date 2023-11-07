import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Customer/Register/ConfirmEmail.dart';
import 'package:qlquanao/utils/Login.dart';
import 'package:qlquanao/database.dart';
import 'package:qlquanao/provider/internet_provider.dart';
import 'package:qlquanao/provider/signin_provider.dart';
import 'package:qlquanao/utils/emailsender.dart';
import 'package:qlquanao/utils/next_screen.dart';
import 'package:qlquanao/utils/snack_bar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../utils/config.dart';
import '../mainpage.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final RoundedLoadingButtonController registerController =
      RoundedLoadingButtonController();

  final email = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  final dob = TextEditingController();

  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  final _scaffoldKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      errorFormatText: 'Ngày không hợp lệ',
      errorInvalidText: 'Ngày không hợp lệ',
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        DateTime de = DateFormat("dd/MM/yyyy").parse(dob.text);
      });
    }
  }

  bool _obscureText = true;
  bool _obscureText1 = true;

  String code = '';

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
              Navigator.pop(context);
              // Xử lý khi người dùng nhấn vào icon trở về
            },
          ),
          backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
          centerTitle: true,
          title: const Text(
            'REGISTER',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Center(
            child: Form(
              key: _scaffoldKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image(
                      image: AssetImage(Config.logo),
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        hintText: "Enter your name",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phone,
                      decoration: InputDecoration(
                        hintText: "Enter Phone Number",
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: TextFormField(
                      keyboardType: TextInputType.datetime,
                      controller: dob,
                      decoration: InputDecoration(
                          hintText: 'DOB',
                          filled: true,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          )),
                    ),
                  ),
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
                      controller: registerController,
                      successColor: Colors.black,
                      color: Colors.black,
                      width: MediaQuery.of(context).size.width * 0.8,
                      elevation: 0,
                      borderRadius: 25,
                      onPressed: () {
                        register(context, phone.text.trim());
                      },
                      child: const Wrap(
                        children: const [
                          Icon(
                            FontAwesomeIcons.registered,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Text('Have account already ?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  Future register(BuildContext context, String mobile) async {
    if (phone.text.isNotEmpty ||
        email.text.isNotEmpty ||
        name.text.isNotEmpty ||
        password.text.isNotEmpty ||
        confirmpassword.text.isNotEmpty) {
      if (email.text.contains("@gmail.com")) {
        if (phone.text.length == 10) {
          if (confirmpassword.text == password.text) {
            if (confirmpassword.text.length > 8) {
              final sp = context.read<SignInProvider>();
              final ip = context.read<InternetProvider>();
              await ip.checkInternetConnection();

              sp.checkEmailExists(email.text.toString()).then((value) async {
                if (value == true) {
                  //user exists
                  openSnackbar(context, "This email is used", Colors.red);
                  registerController.reset();
                } else {
                  //user doesn't exist
                  if (ip.hasInternet == false) {
                    openSnackbar(
                        context, "Check your internet connection", Colors.red);
                  } else {
                    if (_scaffoldKey.currentState!.validate()) {
                      code = createCode();
                      sendingmail(
                          name: name.text.toString().trim(),
                          email: email.text.toString().trim(),
                          subject: 'Reset your password',
                          message: code);
                      registerController.success();
                      //chuyển sang trang xác nhận email
                      checkEmaildata();
                    }
                  }
                }
              });
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Password more 8')));
              registerController.reset();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Confirm password does not match')));
            registerController.reset();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Your phone number must be 10 character')));
          registerController.reset();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please fill correct email format')));
        registerController.reset();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill full information')));
      registerController.reset();
    }
  }

  void checkEmaildata() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmEmail(
                  code: code,
                  email: email.text.toString().trim(),
                  name: name.text.toString().trim(),
                  phone: phone.text.toString().trim(),
                  password: password.text.toString().trim(),
                  dob: dob.text,
                )));
  }

  void handleAfterSingIn() {
    Future.delayed(const Duration(microseconds: 1000)).then((value) {
      nextScreenReplace(context, const MainPage());
    });
  }
}
