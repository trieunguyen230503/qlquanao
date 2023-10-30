import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlquanao/Admin/fragment/MainPageAdmin.dart';

import '../../../../../model/CategoryProduct.dart';
import '../HomePageAdmin.dart';


class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

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

  DatabaseReference dbRef2 = FirebaseDatabase.instance.ref();

  List<CategoryProduct> _categoryList = [];

  String? selectedCategoryUID;
  String? selectedCategoryName;

  @override
  void initState() {
    super.initState();

    dbRef = FirebaseDatabase.instance.ref().child('Product');

    getCategoryData();
  }

  void getCategoryData() {
    dbRef2.child("Category").onChildAdded.listen((data) {
      CategoryProductData categoryProductData =
          CategoryProductData.fromJson(data.snapshot.value as Map);
      CategoryProduct categoryProduct = CategoryProduct(
          key: data.snapshot.key, categoryProductData: categoryProductData);
      _categoryList.add(categoryProduct);
      setState(() {
        selectedCategoryUID = _categoryList.first.categoryProductData!.uid;
        selectedCategoryName = _categoryList.first.categoryProductData!.name;
      });
    });
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
            DropdownButton<String>(
              isExpanded: true,
              value: selectedCategoryName, // Bind to selectedProductName
              items: _categoryList.map((category) {
                return DropdownMenuItem<String>(
                  value: category.categoryProductData!.name,
                  child: Text(category.categoryProductData!.name!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  // Find the selected product in productList
                  final selectedCategory = _categoryList.firstWhere(
                      (category) =>
                          category.categoryProductData!.name == value);

                  // Update the selected product's UID and name
                  selectedCategoryUID =
                      selectedCategory.categoryProductData!.uid;
                  selectedCategoryName =
                      selectedCategory.categoryProductData!.name;
                });
              },
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

                print(selectedCategoryName);
                print(selectedCategoryUID);
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

        double priceValue = double.parse(price.text);
        double promoPriceValue = double.parse(promoPrice.text);

        Map<String, dynamic> Product = {
          'ProductID': productKey,
          'Name': name.text,
          'Price': priceValue,
          'PromoPrice': promoPriceValue,
          'Material': material.text,
          'Description': description.text,
          'url': url,
          'Category': selectedCategoryUID.toString(),
        };

        dbRef!.child(productKey).set(Product).whenComplete(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePageAdmin(),
            ),
          );
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
