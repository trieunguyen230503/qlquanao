import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlquanao/model/ColorProduct.dart';
import 'package:qlquanao/model/SizeProduct.dart';

import '../HomePageAdmin.dart';


class AddProductSizeColor extends StatefulWidget {
  String Product_Key;
  AddProductSizeColor({required this.Product_Key});

  @override
  State<AddProductSizeColor> createState() => _AddProductSizeColorState();
}

class _AddProductSizeColorState extends State<AddProductSizeColor> {

  TextEditingController ProductSizeColorID = TextEditingController();
  late String ProductID;
  TextEditingController SizeID = TextEditingController();
  TextEditingController ColorID = TextEditingController();
  TextEditingController Price = TextEditingController();
  TextEditingController Quantity = TextEditingController();

  File? file;
  ImagePicker image = ImagePicker();
  var url;
  DatabaseReference? dbRef;

  DatabaseReference dbRef2 = FirebaseDatabase.instance.ref();

  //Color
  List<ColorProduct> _colorList = [];

  String? selectedColorUID;
  String? selectedColorName;

  //

  //Size
  List<SizeProduct> _sizeList = [];

  String? selectedSizeUID;
  String? selectedSizeName;

  @override
  void initState() {
    super.initState();

    dbRef = FirebaseDatabase.instance.ref().child('ProductSizeColor');

    getSizeData();
    getProductData();
    getColorData();

  }

  void getProductData() async {
    ProductID = widget.Product_Key;
  }

  void getColorData() {
    dbRef2
        .child("Color")
        .onChildAdded
        .listen((data) {
      ColorProductData colorProductData =
      ColorProductData.fromJson(data.snapshot.value as Map);
      ColorProduct colorProduct = ColorProduct(
          key: data.snapshot.key, colorProductData: colorProductData);
      _colorList.add(colorProduct);
      setState(() {
        selectedColorUID = _colorList.first.colorProductData!.uid;
        selectedColorName = _colorList.first.colorProductData!.name;
      });
    });
  }

  void getSizeData() {
    dbRef2
        .child("Size")
        .onChildAdded
        .listen((data) {
      SizeProductData sizeProductData =
      SizeProductData.fromJson(data.snapshot.value as Map);
      SizeProduct sizeProduct = SizeProduct(
          key: data.snapshot.key, sizeProductData: sizeProductData);
      _sizeList.add(sizeProduct);
      setState(() {
        selectedSizeUID = _sizeList.first.sizeProductData!.uid;
        selectedSizeName = _sizeList.first.sizeProductData!.name;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add ProductSizeColor',
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
                      color: Color.fromARGB(255 , 0, 0, 0),
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
            DropdownButton<String>(
              isExpanded: true,
              value: selectedSizeName, // Bind to selectedProductName
              items: _sizeList.map((size) {
                return DropdownMenuItem<String>(
                  value: size.sizeProductData!.name,
                  child: Text(size.sizeProductData!.name!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  // Find the selected product in productList
                  final selectedSize = _sizeList.firstWhere(
                          (size) =>
                      size.sizeProductData!.name == value);

                  // Update the selected product's UID and name
                  selectedSizeUID =
                      selectedSize.sizeProductData!.uid;
                  selectedSizeName =
                      selectedSize.sizeProductData!.name;
                  print(selectedSizeUID);
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedColorName, // Bind to selectedProductName
              items: _colorList.map((color) {
                return DropdownMenuItem<String>(
                  value: color.colorProductData!.name,
                  child: Text(color.colorProductData!.name!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  // Find the selected product in productList
                  final selectedColor = _colorList.firstWhere(
                          (color) =>
                      color.colorProductData!.name == value);

                  // Update the selected product's UID and name
                  selectedColorUID =
                      selectedColor.colorProductData!.uid;
                  selectedColorName =
                      selectedColor.colorProductData!.name;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: Price,
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
              controller: Quantity,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Quantity',
              ),
              maxLength: 10,
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
          .child("product_size_color_photo")
          .child("/${selectedSizeName}_${selectedColorName}.jpg");
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
      if (url != null) {
        String productSizeColorKey = dbRef!.push().key.toString();

        Map<String, dynamic> ProductSizeColor = {
          'ProductSizeColorID': productSizeColorKey,
          'ProductID': ProductID,
          'SizeID': selectedSizeUID.toString(),
          'ColorID': selectedColorUID.toString(),
          'Price': double.parse(Price.text),
          'Quantity': int.parse(Quantity.text),
          'url': url,
        };

        dbRef!.child(productSizeColorKey)
            .set(ProductSizeColor)
            .whenComplete(() {
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
