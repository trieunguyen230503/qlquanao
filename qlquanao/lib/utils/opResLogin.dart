import 'package:flutter/material.dart';
import 'package:qlquanao/utils/Login.dart';
import 'package:qlquanao/Customer/Register/Register.dart';

class OpResLogin extends StatefulWidget {
  const OpResLogin({super.key});

  @override
  State<OpResLogin> createState() => _OpResLoginState();
}

class _OpResLoginState extends State<OpResLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: const Text(
                    'CREATE AN ACCOUNT',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )))
        ],
      ))),
    );
  }
}
