import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../model/ColorProduct.dart';
import '../../../../../model/SizeProduct.dart';
import 'ManageProductSizeColor.dart';

class UpdateProductSizeColor extends StatefulWidget {
  String ProductSizeColor_Key;
  String ColorUID;
  String SizeUID;
  String ProductUID;

  UpdateProductSizeColor(
      {required this.ProductSizeColor_Key,
      required this.ColorUID,
      required this.SizeUID,
      required this.ProductUID});

  @override
  State<UpdateProductSizeColor> createState() => _UpdateProductSizeColorState();
}

class _UpdateProductSizeColorState extends State<UpdateProductSizeColor> {
  TextEditingController colorID = TextEditingController();
  TextEditingController sizeID = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController quantity = TextEditingController();
  var url;
  var url1;
  File? file;
  ImagePicker image = ImagePicker();
  DatabaseReference? db_Ref;

  DatabaseReference dbRef2 = FirebaseDatabase.instance.ref();

  //Color
  String? selectedColorUID;
  String? selectedColorName;
  List<ColorProduct> _colorList = [];

  //

  //Size
  String? selectedSizeUID;
  String? selectedSizeName;
  List<SizeProduct> _sizeList = [];

  @override
  void initState() {
    super.initState();
    db_Ref = FirebaseDatabase.instance.ref().child('ProductSizeColor');
    ProductSizeColor_data();
    getColorData();
    getSizeData();

    selectedColorName = widget.ColorUID;
  }

  void ProductSizeColor_data() async {
    DataSnapshot snapshot =
        await db_Ref!.child(widget.ProductSizeColor_Key).get();

    Map ProductSizeColor = snapshot.value as Map;

    setState(() {
      colorID.text = ProductSizeColor['ColorID'];
      sizeID.text = ProductSizeColor['SizeID'];
      price.text = ProductSizeColor['Price'].toString();
      quantity.text = ProductSizeColor['Quantity'].toString();
      url = ProductSizeColor['url'];
    });
  }

  void getColorData() {
    dbRef2.child("Color").onChildAdded.listen((data) {
      ColorProductData colorProductData =
          ColorProductData.fromJson(data.snapshot.value as Map);
      ColorProduct colorProduct = ColorProduct(
        key: data.snapshot.key,
        colorProductData: colorProductData,
      );
      _colorList.add(colorProduct);

      if (colorProduct.colorProductData!.uid == widget.ColorUID) {
        setState(() {
          selectedColorUID = colorProduct.colorProductData!.uid;
          selectedColorName = colorProduct.colorProductData!.name;
        });
      }
    });
  }

  void getSizeData() {
    dbRef2.child("Size").onChildAdded.listen((data) {
      SizeProductData sizeProductData =
          SizeProductData.fromJson(data.snapshot.value as Map);
      SizeProduct sizeProduct = SizeProduct(
        key: data.snapshot.key,
        sizeProductData: sizeProductData,
      );
      _sizeList.add(sizeProduct);

      if (sizeProduct.sizeProductData!.uid == widget.SizeUID) {
        setState(() {
          selectedSizeUID = sizeProduct.sizeProductData!.uid;
          selectedSizeName = sizeProduct.sizeProductData!.name;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật sản phẩm'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                child: url == null
                    ? MaterialButton(
                        height: 100,
                        child: Image.file(
                          file!,
                          fit: BoxFit.fill,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      )
                    : MaterialButton(
                        height: 100,
                        child: CircleAvatar(
                          maxRadius: 100,
                          backgroundImage: NetworkImage(
                            url,
                          ),
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
              ),
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
                      (size) => size.sizeProductData!.name == value);

                  // Update the selected product's UID and name
                  selectedSizeUID = selectedSize.sizeProductData!.uid;
                  selectedSizeName = selectedSize.sizeProductData!.name;
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
                      (color) => color.colorProductData!.name == value);

                  // Update the selected product's UID and name
                  selectedColorUID = selectedColor.colorProductData!.uid;
                  selectedColorName = selectedColor.colorProductData!.name;
                });
              },
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
              controller: quantity,
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
                } else {
                  directupdate();
                }
              },
              child: Text(
                "Update",
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
      url = null;
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
      url1 = await snapshot.ref.getDownloadURL();
      setState(() {
        url1 = url1;
      });
      if (url1 != null) {
        Map<String, dynamic> ProductSizeColor = {
          'SizeID': selectedSizeUID.toString(),
          'ColorID': selectedColorUID.toString(),
          'Price': double.parse(price.text),
          'Quantity': int.parse(quantity.text),
          'url': url1,
        };

        db_Ref!
            .child(widget.ProductSizeColor_Key)
            .update(ProductSizeColor)
            .whenComplete(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ManageProductSizeColor(Product_Key: widget.ProductUID),
            ),
          );
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  directupdate() {
    if (url != null) {
      Map<String, dynamic> ProductSizeColor = {
        'SizeID': selectedSizeUID.toString(),
        'ColorID': selectedColorUID.toString(),
        'Price': double.parse(price.text),
        'Quantity': int.parse(quantity.text),
        'url': url,
      };

      db_Ref!
          .child(widget.ProductSizeColor_Key)
          .update(ProductSizeColor)
          .whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ManageProductSizeColor(Product_Key: widget.ProductUID),
          ),
        );
      });
    }
  }
}
