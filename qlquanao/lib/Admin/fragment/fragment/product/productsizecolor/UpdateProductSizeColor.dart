import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlquanao/Admin/fragment/fragment/product/HomePageAdmin.dart';

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
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Update Product Variant',
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
                controller: quantity,
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
                  HomePageAdmin(),
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
                HomePageAdmin(),
          ),
        );
      });
    }
  }
}
