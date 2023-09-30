import 'package:flutter/material.dart';

class ManangeProduct extends StatefulWidget {
  const ManangeProduct({super.key});

  @override
  State<ManangeProduct> createState() => _ManangeProductState();
}

class _ManangeProductState extends State<ManangeProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
        ),
        body: Center(
          child: Text("SẢN PHẨM Ở ĐÂY NÈ KU"),
        ));
  }
}
