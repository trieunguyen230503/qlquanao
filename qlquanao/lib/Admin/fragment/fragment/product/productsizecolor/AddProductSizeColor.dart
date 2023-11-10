import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Product Variant',
          style: GoogleFonts.getFont(
            'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF758467),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.03, vertical:  MediaQuery.of(context).size.width * 0.05),
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
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    items: _sizeList
                        .map((size) => DropdownMenuItem<String>(
                      value: size.sizeProductData!.name,
                      child: Text(
                        size.sizeProductData!.name!,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ))
                        .toList(),
                    value: selectedSizeName,
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.02),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 2
                          ),
                          borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: MediaQuery.of(context).size.height * 0.075,
                    ),
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
                      });
                    },
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    items: _colorList
                        .map((color) => DropdownMenuItem<String>(
                      value: color.colorProductData!.name,
                      child: Text(
                        color.colorProductData!.name!,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ))
                        .toList(),
                    value: selectedColorName,
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.02),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 2
                          ),
                          borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: MediaQuery.of(context).size.height * 0.075,
                    ),
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
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextFormField(
                controller: Price,
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Price',
                  labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  ),
                  hintText: 'Enter your price here...',
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
              TextFormField(
                controller: Quantity,
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  ),
                  hintText: 'Enter your quantity here...',
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
                    if (file != null) {
                      uploadFile();
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.info, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Please add a photo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          backgroundColor: Color(0xFF758467),
                          duration: const Duration(seconds: 3),
                          action: SnackBarAction(
                            label: 'Close',
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                            textColor: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
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
