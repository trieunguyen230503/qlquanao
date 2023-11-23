import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/Customer/Order/PaymentPage.dart';
import 'package:qlquanao/model/Cart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qlquanao/utils/Login.dart';

import '../../provider/signin_provider.dart';

// String formatPrice(int price) {
//   final formatter = NumberFormat("#,###");
//   return formatter.format(price);
// }

List<Cart> selectedProducts = [];

int totalAmount = 0;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> cartList = [];
  String? uid;

  @override
  void initState() {
    super.initState();
    // Lấy id user đang đăng nhập
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreference();
    uid = sp.uid;

    selectedProducts.clear();
    getCartFromFirebase();
  }

  void getCartFromFirebase() async {
    // Khởi tạo tham chiếu đến cơ sở dữ liệu Firebase
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("cart");

    if (!mounted) {
      return;
    }
    databaseRef.onValue.listen((event) {
      if (cartList.isNotEmpty) {
        cartList.clear();
      }

      for (final child in event.snapshot.children) {
        String userID = child.child("userID").value.toString();

        if (userID == uid) {
          String idCart = child.child("idCart").value.toString();
          String productID = child.child("productID").value.toString();
          String productName = child.child("productName").value.toString();
          String color = child.child("color").value.toString();
          String size = child.child("size").value.toString();
          String image = child.child("productImage").value.toString();
          int price = int.parse(child.child("totalAmount").value.toString());
          int quantity = int.parse(child.child("quantity").value.toString());
          Cart p = Cart(
              idCart: idCart,
              productID: productID,
              productName: productName,
              image: image,
              color: color,
              size: size,
              price: price,
              quantity: quantity,
              userID: userID);
          cartList.add(p);
        }
      }
      if (!mounted) return;
      setState(() {
        cartList = cartList.reversed.toList();
      });
    }, onError: (error) {
      // Error.
    });
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormatterUSD =
        NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return Scaffold(
      body: ListView(
        children: [
          CartAppBar(),
          (uid == null)
              ? Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text("Please LOG IN",
                            style:
                                TextStyle(fontSize: 20, color: Colors.blue))),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height - 180,
                  padding: EdgeInsets.only(top: 10, bottom: 70),
                  decoration: BoxDecoration(
                    color: Color(0xFFEDECF2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartList[index];
                        return Container(
                          height: 110,
                          margin: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
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
                                value: selectedProducts.contains(cartItem),
                                onChanged: (bool? value) {
                                  if (mounted) {
                                    setState(() {
                                      if (value != null) {
                                        if (value) {
                                          if (!selectedProducts
                                              .contains(cartItem)) {
                                            selectedProducts.add(cartItem);
                                          }
                                        } else {
                                          selectedProducts.remove(cartItem);
                                        }
                                      }
                                      totalAmount = 0;
                                      for (var p in selectedProducts) {
                                        totalAmount += (p.price * p.quantity);
                                      }
                                    });
                                  }
                                },
                              ),
                              Container(
                                height: 70,
                                width: 70,
                                margin: EdgeInsets.only(right: 10),
                                child: Image.network(cartItem.image),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (cartItem.productName.length > 12)
                                          ? '${cartItem.productName.substring(0, 12)}...' // Hiển thị 'text...' nếu độ dài vượt quá length
                                          : cartItem.productName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      cartItem.color + ", " + cartItem.size,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF4C53A5),
                                      ),
                                    ),
                                    Text(
                                      currencyFormatterUSD
                                          .format(cartItem.price),
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
                                      onTap: () =>
                                          _deleteItemInCart(context, cartItem),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.black26,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (cartItem.quantity > 1) {
                                              setState(() {
                                                cartItem.quantity--;
                                                //Nếu người dùng ấn giảm sl trong lúc sp đã chọn thì giảm giá tổng
                                                if (selectedProducts
                                                    .contains(cartItem)) {
                                                  totalAmount -= cartItem.price;
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: cartItem.quantity == 1
                                                  ? Colors.black12
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
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
                                            cartItem.quantity.toString().trim(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              cartItem.quantity++;
                                              //Nếu người dùng ấn tăng sl trong lúc sp đã chọn thì tăng thêm giá tổng
                                              if (selectedProducts
                                                  .contains(cartItem)) {
                                                totalAmount += cartItem.price;
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
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
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

  void _deleteItemInCart(BuildContext context, Cart c) {
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("cart");
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${c.productName}?'),
          content: const Text('The product will be removed from your cart!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (!mounted) {
                    return; // Đảm bảo widget vẫn còn trong cây widget
                  }
                  setState(() {
                    databaseRef.child(c.idCart).remove();
                  });
                },
                child: Text("Yes")),
          ],
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
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
              "Cart",
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
  NumberFormat currencyFormatterUSD =
      NumberFormat.currency(locale: 'en_US', symbol: '\$');

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
                  "Total:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currencyFormatterUSD.format(totalAmount),
                  style: TextStyle(
                    fontSize: 25,
                    color: Color(0xFF4C53A5),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                if (selectedProducts.length == 0) {
                  Fluttertoast.showToast(
                      msg: "Please choose a product",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentPage(
                                listProduct: selectedProducts,
                              )));
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
                  "Check out",
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
