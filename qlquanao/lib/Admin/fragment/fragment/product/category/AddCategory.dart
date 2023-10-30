import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ManageCategory.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController cateName = TextEditingController();

  final fb = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    var k = fb.child('Category').push().key;
    final ref = fb.child('Category/$k');

    return  Scaffold(
      appBar: AppBar(
        title: Text("Thêm phân loại"),
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
                controller: cateName,
                decoration: InputDecoration(
                  hintText: 'Tên loại',
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
                  "CateID": k,
                  "Name": cateName.text,
                }).asStream();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => ManageCategory()));
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