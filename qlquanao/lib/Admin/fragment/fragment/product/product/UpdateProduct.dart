import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlquanao/Admin/fragment/MainPageAdmin.dart';
import 'package:qlquanao/model/CategoryProduct.dart';

import '../HomePageAdmin.dart';

class UpdateProduct extends StatefulWidget {
  String Product_Key;
  String CategoryUID;

  UpdateProduct({required this.Product_Key, required this.CategoryUID});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController promoPrice = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController material = TextEditingController();
  TextEditingController description = TextEditingController();
  var url;
  var url1;
  File? file;
  ImagePicker image = ImagePicker();
  DatabaseReference? db_Ref;
  DatabaseReference dbRef2 = FirebaseDatabase.instance.ref();

  //Category
  String? selectedCategoryUID;
  String? selectedCategoryName;
  List<CategoryProduct> _categoryList = [];

  @override
  void initState() {
    super.initState();
    db_Ref = FirebaseDatabase.instance.ref().child('Product');
    Product_data();
    getCategoryData();
  }

  void Product_data() async {
    DataSnapshot snapshot = await db_Ref!.child(widget.Product_Key).get();

    Map Product = snapshot.value as Map;

    setState(() {
      name.text = Product['Name'];
      price.text = Product['Price'].toString();
      promoPrice.text = Product['PromoPrice'].toString();
      material.text = Product['Material'];
      description.text = Product['Description'];
      category.text = Product['Category'];
      url = Product['url'];
    });
  }

  void getCategoryData() {
    dbRef2.child("Category").onChildAdded.listen((data) {
      CategoryProductData categoryProductData =
          CategoryProductData.fromJson(data.snapshot.value as Map);
      CategoryProduct categoryProduct = CategoryProduct(
        key: data.snapshot.key,
        categoryProductData: categoryProductData,
      );
      _categoryList.add(categoryProduct);

      if (categoryProduct.categoryProductData!.uid == widget.CategoryUID) {
        setState(() {
          selectedCategoryUID = categoryProduct.categoryProductData!.uid;
          selectedCategoryName = categoryProduct.categoryProductData!.name;
        });
      }
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
          'Update Product',
          style: GoogleFonts.getFont(
            'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF758467),
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
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(url,width: 200,height: 200,),
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ),
                ),
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
                    'UPDATE',
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
                      directupdate();
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
      url = null;
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
      url1 = await snapshot.ref.getDownloadURL();
      setState(() {
        url1 = url1;
      });
      if (url1 != null) {
        Map<String, dynamic> Product = {
          'Name': name.text,
          'Price': double.parse(price.text),
          'PromoPrice': double.parse(promoPrice.text),
          'Material': material.text,
          'Description': description.text,
          'Category': selectedCategoryUID.toString(),
          'url': url1,
        };

        db_Ref!.child(widget.Product_Key).update(Product).whenComplete(() {
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

  directupdate() {
    if (url != null) {
      Map<String, dynamic> Product = {
        'Name': name.text,
        'Price': double.parse(price.text),
        'PromoPrice': double.parse(promoPrice.text),
        'Material': material.text,
        'Description': description.text,
        'Category': selectedCategoryUID.toString(),
        'url': url,
      };

      db_Ref!.child(widget.Product_Key).update(Product).whenComplete(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomePageAdmin()));
      });
    }
  }
}
