import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'ManageSize.dart';

class AddSize extends StatefulWidget {

  @override
  State<AddSize> createState() => _AddSizeState();
}

class _AddSizeState extends State<AddSize> {

  TextEditingController sizeName = TextEditingController();


  final fb = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    //Get key = datetime
    var k = fb.child('Size').push().key;
    final ref = fb.child('Size/$k');
    //

    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Size',
          style: GoogleFonts.getFont(
            'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF758467),

      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.03, vertical:  MediaQuery.of(context).size.width * 0.05),
          child: Column(
            children: [
              TextFormField(
                controller: sizeName,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  ),
                  hintText: 'Enter your category here...',
                  hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.075,),
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02,bottom: MediaQuery.of(context).size.height * 0.05,),
                decoration: BoxDecoration(
                    color: Color(0xFF758467),
                    borderRadius: BorderRadius.circular(30.0)),
                child: TextButton(
                  //Tắt hiệu ứng splash khi click button
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: Text(
                    'ADD',
                    style: GoogleFonts.getFont(
                      'Montserrat',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    ref.set({
                      "SizeID": k,
                      "Name": sizeName.text,
                    }).asStream();
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => ManageSize()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
