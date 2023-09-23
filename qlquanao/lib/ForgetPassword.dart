import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server.dart';
import 'package:qlquanao/ConfirmPassword.dart';
import 'package:qlquanao/mainpage.dart';
import 'package:mailer/mailer.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final userName = TextEditingController();
  String code = '';

  Future sendingmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final serviceId = 'service_r7dhupk';
    final templateId = 'template_xwvj42x';
    final userId = '7mJ2R_-Khlx7l0ysl';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': subject,
          'user_message': message,
        }
      }),
    );
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'ConfirmPass': (context) => ConfirmPassword(
              code: '',
              email: '',
            ),
      },
      home: Scaffold(
        appBar: AppBar(
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
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: TextFormField(
                  controller: userName,
                  decoration: InputDecoration(
                      hintText: "Enter your email/Phone Number",
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
                    //gán mã code
                    code = createCode();
                    print(code);
                    sendingmail(
                        name: 'Trieu',
                        email: userName.text.toString(),
                        subject: 'Reset your password',
                        message: code);

                    //Chuyển đoạn code sang trang ConfirmPassword
                    checkEmaildata();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  child: const Text(
                    'LOGIN',
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

  String createCode() {
    const String characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String randomString = '';

    for (int i = 0; i < 5; i++) {
      int randomIndex = random.nextInt(characters.length);
      randomString += characters[randomIndex];
    }
    return randomString;
  }

  void checkEmaildata() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ConfirmPassword(code: code, email: userName.text.toString())));
  }
}
