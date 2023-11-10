import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Product',
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
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 90,
                              color: Color(0xFF758467),
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
              TextFormField(
                controller: name,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                  ),
                  hintText: 'Enter your product name here...',
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
                controller: price,
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
                controller: promoPrice,
                keyboardType: TextInputType.number,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Promo Price',
                  labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  ),
                  hintText: 'Enter your promo price here...',
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
                controller: material,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Material',
                  labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  ),
                  hintText: 'Enter material here...',
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
                controller: description,
                obscureText: false,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  ),
                  hintText: 'Enter description here...',
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    items: _categoryList
                        .map((category) => DropdownMenuItem<String>(
                      value: category.categoryProductData!.name,
                      child: Text(
                        category.categoryProductData!.name!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ))
                        .toList(),
                    value: selectedCategoryName,
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
