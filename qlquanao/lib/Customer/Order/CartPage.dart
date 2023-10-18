import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qlquanao/Customer/Order/paymentPage.dart';
import 'package:qlquanao/model/Product.dart';
import 'package:firebase_database/firebase_database.dart';


String formatPrice(int price) {
  final formatter = NumberFormat("#,###");
  return formatter.format(price);
}

List<Product> selectedProducts = [];

int totalAmount = 0;


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  List<Product> cartItems = [];

  @override
  void initState() {
    super.initState();
    getCartFromFirebase();
  }

  void getCartFromFirebase() async{
    // Khởi tạo tham chiếu đến cơ sở dữ liệu Firebase
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("cart");

    await databaseRef.onValue.listen((event) {
      if(cartItems.isNotEmpty){
        cartItems.clear();
      }

      for (final child in event.snapshot.children) {
        String name = child.child("product").child("name").value.toString();
        String color = child.child("color").value.toString();
        String size = child.child("size").value.toString();
        String image = child.child("product").child("image").value.toString();
        int price = int.parse(child.child("totalAmount").value.toString());
        int quantity = int.parse(child.child("quantity").value.toString());
        Product p = Product(name: name, image: image, color: color, size: size, price: price, quantity: quantity);
          print(p.toString());
          setState(() {
            cartItems.add(p);
          });
          print(cartItems.length.toString());
      }
    }, onError: (error) {
      // Error.
    });


    // final databaseRef = FirebaseDatabase.instance.ref("cart");
    // databaseRef.onChildAdded.listen((event) {
    //   for (final child in event.snapshot.children) {
    //     final price = child.child("totalAmount").value;
    //     final specificValue = child.child("product").child("name").value;
    //     print("sản phẩm: " + specificValue.toString());
    //   }
    // }, onError: (error) {
    //   // Error.
    // });
    // databaseRef.onChildChanged.listen((event) {
    //   // A comment has changed; use the key to determine if we are displaying this
    //   // comment and if so displayed the changed comment.
    // });
    // databaseRef.onChildRemoved.listen((event) {
    //   // A comment has been removed; use the key to determine if we are displaying
    //   // this comment and if so remove it.
    // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          CartAppBar(),
          Container(
            height: 700,
            padding: EdgeInsets.only(top: 10, bottom: 70),
            decoration: BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final product = cartItems[index];
                  return Container(
                    height: 110,
                    margin:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.black,
                          activeColor: Colors.grey,
                          value: selectedProducts.contains(product),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                if (value) {
                                  if (!selectedProducts.contains(product)) {
                                    selectedProducts.add(product);
                                  }
                                } else {
                                  selectedProducts.remove(product);
                                }
                              }
                              totalAmount = 0;
                              for(var p in selectedProducts){
                                totalAmount += (p.price * p.quantity);
                              }
                            });
                          },
                        ),

                        Container(
                          height: 70,
                          width: 70,
                          margin: EdgeInsets.only(right: 10),
                          child: Image.network(product.image),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (product.name.length > 15)
                                    ? '${product.name.substring(0, 15)}...' // Hiển thị 'text...' nếu độ dài vượt quá length
                                    : product.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                product.color + ", " + product.size,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4C53A5),
                                ),
                              ),
                              Text(
                                formatPrice(product.price) + "đ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => _deleteItemInCart(context, product),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.black26,
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      if(product.quantity > 1){
                                        setState(() {
                                          product.quantity--;
                                          //Nếu người dùng ấn giảm sl trong lúc sp đã chọn thì giảm giá tổng
                                          if(selectedProducts.contains(product)){
                                            totalAmount -= product.price;
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: product.quantity == 1 ? Colors.black12 : Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                          )
                                        ],
                                      ),
                                      child: Icon(
                                        CupertinoIcons.minus,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      product.quantity.toString().trim(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        product.quantity++;
                                        //Nếu người dùng ấn tăng sl trong lúc sp đã chọn thì tăng thêm giá tổng
                                        if(selectedProducts.contains(product)){
                                          totalAmount += product.price;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                          )
                                        ],
                                      ),
                                      child: Icon(
                                        CupertinoIcons.plus,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
      bottomNavigationBar: CartBottomNavBar(),
    );
  }

  void _deleteItemInCart(BuildContext context, Product product) {
    print("delete " + product.name);
  }
}





class CartAppBar extends StatefulWidget {
  const CartAppBar({super.key});

  @override
  State<CartAppBar> createState() => _CartAppBarState();
}

class _CartAppBarState extends State<CartAppBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Giỏ hàng",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}






class CartBottomNavBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        height: 130,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tổng tiền:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatPrice(totalAmount) + "đ",
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xFF4C53A5),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                if(selectedProducts.length == 0){
                  Fluttertoast.showToast(
                      msg: "Chưa chọn sản phẩm",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
                else{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(danhSach: selectedProducts,)));
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Thanh toán",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
