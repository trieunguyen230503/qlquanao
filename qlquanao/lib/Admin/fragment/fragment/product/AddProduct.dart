import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlquanao/Admin/fragment/MainPageAdmin.dart';


import 'ManageProduct.dart';

class AddProduct extends StatefulWidget {

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController promoPrice = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController material = TextEditingController();
  TextEditingController description = TextEditingController();

  File? file;
  ImagePicker image = ImagePicker();
  var url;
  DatabaseReference? dbRef;
  List<String> _item = [];

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('products');

    fetchData();

    print(_item.toString());
  }

  Future<List<String>> fetchData() async {
    // Fetch data from Firebase
    DataSnapshot snapshot = (await FirebaseDatabase.instance.ref().child('categories').once()) as DataSnapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map;
      // Loop through the retrieved data and add values where key is 'nameCate' to _item list
      values.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          var nameCate = value['nameCate'];
          if (nameCate != null) {
            _item.add(nameCate);
          }
        }
      });
    }

    return _item;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Products',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  height: 200,
                  width: 200,
                  child: file == null
                      ? IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      size: 90,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      getImage();
                    },
                  )
                      : MaterialButton(
                    height: 100,
                    child: Image.file(
                      file!,
                      fit: BoxFit.fill,
                    ),
                    onPressed: () {
                      getImage();
                    },
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Name',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Price',
              ),
              maxLength: 10,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: promoPrice,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Promo Price',
              ),
              maxLength: 10,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: material,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Material',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: description,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Description',
              ),
            ),
            SizedBox(
              height: 20,
            ),


            MaterialButton(
              height: 40,
              onPressed: () {
                // getImage();

                if (file != null) {
                  uploadFile();
                }
              },
              child: Text(
                "Add",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 20,
                ),
              ),
              color: Colors.indigo[900],
            ),
          ],
        ),
      ),
    );
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    // print(file);
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("product_photo")
          .child("/${name.text}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
        String productKey = dbRef!.push().key.toString();
        Map<String, String> Product = {
          'uid': productKey,
          'name': name.text,
          'price': price.text,
          'promoprice': promoPrice.text,
          'material': material.text,
          'description': description.text,
          'url': url,
        };

        dbRef!.child(productKey).set(Product).whenComplete(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => MainPageAdmin(),
            ),
          );
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
