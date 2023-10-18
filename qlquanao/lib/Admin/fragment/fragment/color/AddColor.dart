import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'ManageColor.dart';

class AddColor extends StatefulWidget {

  @override
  State<AddColor> createState() => _AddColorState();
}

class _AddColorState extends State<AddColor> {

  TextEditingController productName = TextEditingController();

  TextEditingController productPrice = TextEditingController();

  final fb = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    //Get key = datetime
    var k = fb.child('colors').push().key;
    final ref = fb.child('colors/$k');
    //

    return  Scaffold(
      appBar: AppBar(
        title: Text("Thêm màu sắc"),
        backgroundColor: Colors.indigo[900],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: productName,
                decoration: InputDecoration(
                  hintText: 'Tên màu sắc',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: productPrice,
                decoration: InputDecoration(
                  hintText: 'Hex màu sắc',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.indigo[900],
              onPressed: () {
                ref.set({
                  "colorName": productName.text,
                  "colorHex": productPrice.text,
                }).asStream();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => ManageColor()));
              },
              child: Text(
                "save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
