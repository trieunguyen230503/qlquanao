import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
