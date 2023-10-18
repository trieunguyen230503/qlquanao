import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'ManageSize.dart';

class AddSize extends StatefulWidget {

  @override
  State<AddSize> createState() => _AddSizeState();
}

class _AddSizeState extends State<AddSize> {

  TextEditingController productName = TextEditingController();

  TextEditingController productPrice = TextEditingController();

  final fb = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    //Get key = datetime
    var k = fb.child('sizes').push().key;
    final ref = fb.child('sizes/$k');
    //

    return  Scaffold(
      appBar: AppBar(
        title: Text("Thêm kích thước"),
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
                  hintText: 'Kích thước',
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
                  hintText: 'Mô tả',
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
                  "sizeName": productName.text,
                  "sizeDescription": productPrice.text,
                }).asStream();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => ManageSize()));
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
