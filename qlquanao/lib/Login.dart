import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qlquanao/ForgetPassword.dart';
import 'package:qlquanao/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Register.dart';
import 'database.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userName = TextEditingController();
  final password = TextEditingController();

  bool _isChecked = false;
  bool _obscureText = true;

  late SharedPreferences logindata;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
  }

  void check() async {
    logindata = await SharedPreferences.getInstance();
  }

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
          'LOGIN',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: TextFormField(
                  obscureText: _obscureText,
                  controller: password,
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
              CheckboxListTile(
                title: Text('Remember your password ?'),
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: 50,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    login();
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
                onTap: () {},
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 200,
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0)),
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  //color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Icon(
                            Icons.facebook_outlined,
                            color: Colors.blue,
                            size: 30,
                          )),
                      Expanded(
                          child: Text(
                            'Sign in With Facebook',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ))
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 200,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  //color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                          // Điều chỉnh khoảng cách xung quanh
                          child: FaIcon(
                            FontAwesomeIcons.google,
                            size: 25.0, // Điều chỉnh kích thước của biểu tượng
                            color: Colors.red, // Điều chỉnh màu của biểu tượng
                          ),
                        ),
                      ),
                      Expanded(
                          child: Text(
                            'Sign in With Google',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ))
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Text('Do not have account ?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ForgetPassword()));
                },
                child: Text('Forget your password ?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    if (userName.text.isNotEmpty && password.text.isNotEmpty) {
      String username = userName.text.toString();
      String password1 = password.text.toString();
      // gọi hàm checkLogin bên database.dart với tham số vào là username và password
      DBHelper dbHelper = DBHelper();
      bool isLoggedin = await dbHelper.checkLogin(username, password1);

      if (isLoggedin) {
        //Không cần ấn checkbox vẫn lưu tên người dùng
        logindata.setString('username', username);
        logindata.setBool('login', true);
        Navigator.push(context, MaterialPageRoute(builder: (_) => MainPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sai tài khoản hoặc mật khẩu')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Vui lòng điền đầy đủ')));
    }
  }
}
