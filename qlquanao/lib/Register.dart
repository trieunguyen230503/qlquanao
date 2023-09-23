import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qlquanao/Login.dart';
import 'package:qlquanao/database.dart';

import 'auth_bloc.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthBloc authBloc = new AuthBloc();
  DBHelper dbHelper = new DBHelper();

  final userName = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();

  bool _obscureText = true;
  bool _obscureText1 = true;


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
          'REGISTER',
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
                  controller: userName,
                  decoration: InputDecoration(
                    hintText: "Enter your email/Phone Number",
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
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    check();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  child: const Text(
                    'REGISTER',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
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
    );
    ;
  }

  void check() async {
    await dbHelper.copyDB();
    if (userName.text.length > 5) {
      if (confirmpassword.text == password.text) {
        if (confirmpassword.text.length > 8) {
          dbHelper.registerDB(userName.text, password.text).then((check) {
            if (check) {
              // LoadingDialog.showLoadingDialog(context, "Vui lòng đợi...");
              Fluttertoast.showToast(
                  msg: "Success",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color.fromRGBO(125, 31, 31, 1.0),
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            }
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Password more 8')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Confirm password does not match')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User name have more than 5')));
    }
  }
}
