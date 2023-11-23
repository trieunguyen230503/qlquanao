import 'package:bcrypt/bcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:qlquanao/Admin/fragment/MainPageAdmin.dart';
import 'package:qlquanao/Staff/fragment/MainPageStaff.dart';
import 'package:qlquanao/provider/internet_provider.dart';
import 'package:qlquanao/provider/signin_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qlquanao/Customer/GetNewPassword/ForgetPassword.dart';
import 'package:qlquanao/Customer/mainpage.dart';
import 'package:qlquanao/utils/next_screen.dart';
import 'package:qlquanao/utils/snack_bar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../Customer/Register/Register.dart';
import '../database.dart';
import 'config.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userName = TextEditingController();
  final password = TextEditingController();
  final otpCodeController = TextEditingController();
  bool _isChecked = false;
  bool _obscureText = true;

  late SharedPreferences logindata;
  final _scaffoldKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController loginController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();

  String pss = "test";

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
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
          centerTitle: true,
          title: const Text(
            'LOGIN',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Form(
              key: _scaffoldKey,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    Container(
                      width: MediaQuery.of(context).size.width,
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
                    SizedBox(
                      height: 20,
                    ),
                    RoundedLoadingButton(
                        controller: loginController,
                        color: Colors.black,
                        successColor: Colors.black,
                        width: MediaQuery.of(context).size.width * 0.8,
                        elevation: 0,
                        borderRadius: 25,
                        onPressed: () {
                          login(context, userName.text.trim());
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
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    RoundedLoadingButton(
                        controller: googleController,
                        color: Colors.red,
                        successColor: Colors.red,
                        width: MediaQuery.of(context).size.width * 0.8,
                        elevation: 0,
                        borderRadius: 25,
                        onPressed: () {
                          handleGoogle();
                        },
                        child: Wrap(
                          children: const [
                            Icon(
                              FontAwesomeIcons.google,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Sign in with google',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    RoundedLoadingButton(
                        controller: facebookController,
                        successColor: Colors.blue,
                        width: MediaQuery.of(context).size.width * 0.8,
                        elevation: 0,
                        borderRadius: 25,
                        onPressed: () {
                          handleFacebook();
                        },
                        child: Wrap(
                          children: const [
                            Icon(
                              FontAwesomeIcons.facebook,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Sign in with Facebook',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        )),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPassword()));
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
          ),
        ));
  }

  Future login(BuildContext context, String mobile) async {
    if (userName.text.isNotEmpty && password.text.isNotEmpty) {
      String email = userName.text.toString().trim();
      String password1 = password.text.toString().trim();
      // gọi hàm checkLogin bên database.dart với tham số vào là username và password
      final sp = context.read<SignInProvider>();
      final ip = context.read<InternetProvider>();
      await ip.checkInternetConnection();

      sp.checkEmailLogin(email, password1).then((value) async {
        if (value == true) {
          await sp
              .saveDataToSharedPreferences()
              .then((value) => sp.setSignIn().then((value) => {
                    loginController.success(),
                    handleAfterSingIn(),
                  }));
        } else {
          openSnackbar(context, "Your information is not correct", Colors.red);
          loginController.reset();
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Vui lòng điền đầy đủ')));
      loginController.reset();
    }
  }

  //handling google signin in
  Future handleGoogle() async {
    final sp = context.read<SignInProvider>();
    //internet provider
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) => {
            if (sp.hasError == true)
              {
                openSnackbar(context, sp.errorCode, Colors.red),
                googleController.reset()
              }
            else
              {
                //checkking whether user exist or not
                sp.checkUserExists().then((value) async {
                  if (value == true) {
                    //user exists
                    await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) => {
                              googleController.success(),
                              handleAfterSingIn(),
                            })));
                  } else {
                    //user doesn't exist
                    sp.saveDateToFirestore().then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) {
                              googleController.success();
                              handleAfterSingIn();
                            })));
                  }
                })
              }
          });
    }
  }

  Future handleFacebook() async {
    final sp = context.read<SignInProvider>();
    //internet provider
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your Internet connection", Colors.red);
      facebookController.reset();
    } else {
      await sp.signInWithFacebook().then((value) => {
            if (sp.hasError == true)
              {
                openSnackbar(context, sp.errorCode, Colors.red),
                facebookController.reset()
              }
            else
              {
                //checkking whether user exist or not
                sp.checkUserExists().then((value) async {
                  if (value == true) {
                    //user exists
                    await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) => {
                              facebookController.success(),
                              handleAfterSingIn(),
                            })));
                  } else {
                    //user doesn't exist
                    sp.saveDateToFirestore().then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) {
                              facebookController.success();
                              handleAfterSingIn();
                            })));
                  }
                })
              }
          });
    }
  }

  void handleAfterSingIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    int? _role = s.getInt('role');
    print(_role);
    if (_role == 1) {
      Future.delayed(const Duration(microseconds: 1000)).then((value) {
        nextScreenReplace(context, const MainPageAdmin());
      });
    } else if (_role == 2) {
      Future.delayed(const Duration(microseconds: 1000)).then((value) {
        nextScreenReplace(context, const MainPageStaff());
      });
    } else {
      Future.delayed(const Duration(microseconds: 1000)).then((value) {
        nextScreenReplace(context, const MainPage());
      });
    }
  }
}
